Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2HGSjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:39:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32791 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab2HGSja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:39:30 -0400
Date: Tue, 7 Aug 2012 11:39:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, sjur.brandeland@stericsson.com
Subject: Re: [PATCHv2 3/4] modem_shm: u8500-shm: U8500 Shared Memory Driver
Message-ID: <20120807183925.GD26990@kroah.com>
References: <1344322471-3640-1-git-send-email-arun.murthy@stericsson.com>
 <1344322471-3640-4-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344322471-3640-4-git-send-email-arun.murthy@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 12:24:30PM +0530, Arun Murthy wrote:
> The communication between APE and CMT in u8500 is by means of a shared DDR.
> Since its a shared memory, this driver implements shrm protocol.
> 
> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/modem_shm/Kconfig                        |    2 +
>  drivers/modem_shm/Makefile                       |    1 +
>  drivers/modem_shm/u8500_shm/Kconfig              |   43 +
>  drivers/modem_shm/u8500_shm/Makefile             |    7 +
>  drivers/modem_shm/u8500_shm/shrm_char.c          |  895 ++++++++++++
>  drivers/modem_shm/u8500_shm/shrm_driver.c        |  732 ++++++++++
>  drivers/modem_shm/u8500_shm/shrm_fifo.c          |  837 ++++++++++++
>  drivers/modem_shm/u8500_shm/shrm_net.c           |  312 +++++
>  drivers/modem_shm/u8500_shm/shrm_protocol.c      | 1590 ++++++++++++++++++++++
>  include/linux/modem_shm/u8500_shm/shrm.h         |   23 +
>  include/linux/modem_shm/u8500_shm/shrm_config.h  |  114 ++
>  include/linux/modem_shm/u8500_shm/shrm_driver.h  |  225 +++
>  include/linux/modem_shm/u8500_shm/shrm_ioctl.h   |   43 +
>  include/linux/modem_shm/u8500_shm/shrm_net.h     |   46 +
>  include/linux/modem_shm/u8500_shm/shrm_private.h |  183 +++

Why do any of those .h files need to be in include/linux/*?  Shouldn't
they just be in the same directory as the driver itself?

greg k-h
