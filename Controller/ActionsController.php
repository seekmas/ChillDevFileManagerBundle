<?php

/**
 * This file is part of the ChillDev FileManager bundle.
 *
 * @author Rafał Wrzeszcz <rafal.wrzeszcz@wrzasq.pl>
 * @copyright 2014 © by Rafał Wrzeszcz - Wrzasq.pl.
 * @version 0.1.4
 * @since 0.1.3
 * @package ChillDev\Bundle\FileManagerBundle
 */

namespace ChillDev\Bundle\FileManagerBundle\Controller;

use ChillDev\Bundle\FileManagerBundle\Action\Handler\HandlerInterface;
use ChillDev\Bundle\FileManagerBundle\Filesystem\Disk;
use ChillDev\Bundle\FileManagerBundle\Utils\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

use Symfony\Component\HttpFoundation\Request;

/**
 * Custom actions controller.
 *
 * @Route("/actions")
 * @author Rafał Wrzeszcz <rafal.wrzeszcz@wrzasq.pl>
 * @copyright 2014 © by Rafał Wrzeszcz - Wrzasq.pl.
 * @version 0.1.3
 * @since 0.1.3
 * @package ChillDev\Bundle\FileManagerBundle
 */
class ActionsController extends BaseController
{
    /**
     * Custom action handler trigger.
     *
     * @Route(
     *      "/{action}/{disk}/{path}",
     *      name="chilldev_filemanager_actions_handle",
     *      requirements={"path"=".*"}
     *  )
     * @param Request $request Current request.
     * @param HandlerInterface $action Requested action.
     * @param Disk $disk Disk scope.
     * @param string $path Subject of action.
     * @return \Symfony\Component\HttpFoundation\Response Response generated by action handler.
     * @throws \Symfony\Component\HttpKernel\Exception\HttpException When requested path is invalid or is not a file.
     * @throws \Symfony\Component\HttpKernel\Exception\NotFoundHttpException When requested path does not exist.
     * @version 0.1.3
     * @since 0.1.3
     */
    public function handleAction(Request $request, HandlerInterface $action, Disk $disk, $path)
    {
        $path = Controller::resolvePath($path);

        // get filesystem from given disk
        $filesystem = $disk->getFilesystem();

        Controller::ensureExist($disk, $filesystem, $path);

        $this->logUserAction($disk, sprintf('Action "%s" is executed on file "%s"', $action->getLabel(), $path));

        return $action->handle($request, $disk, $path);
    }
}
