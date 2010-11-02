Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0KBHg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:36:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62313 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab0KBHgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:36:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xdiP7Cyi1YiluBWQ7H1TuCoEaN/Odadqv++xG/9jY6LCFGLFQtkMj5ypRNg8U9CY2A
         mspqbRtKc5eSRrSllsxK/pW9kiIOq33txhcY4lG/Q4yxpCu1WD8V14WizGW0PDcLKySN
         Cg5TZTOQOx54yBeWUXPPcdYDAc5RXpnywN+a0=
Message-ID: <4CCFBF8F.6090906@suse.cz>
Date: Tue, 02 Nov 2010 08:36:47 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: fix typos/errors in tty_driver.h comments
References: <1288625926-26293-1-git-send-email-timur@freescale.com>
In-Reply-To: <1288625926-26293-1-git-send-email-timur@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 04:38 PM, Timur Tabi wrote:
> Fix various typos and other errors in comments of tty_driver.h.  The most
> significant is the wrong name of a function for the description of
> TTY_DRIVER_DYNAMIC_DEV.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>

ACK, but you should CC maintainer (Greg KH).

> ---
>  include/linux/tty_driver.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
> index b086779..6c4e42f 100644
> --- a/include/linux/tty_driver.h
> +++ b/include/linux/tty_driver.h
> @@ -102,7 +102,7 @@
>   * 	    unsigned int cmd, unsigned long arg);
>   *
>   * 	This routine allows the tty driver to implement
> - *	device-specific ioctl's.  If the ioctl number passed in cmd
> + * 	device-specific ioctls.  If the ioctl number passed in cmd
>   * 	is not recognized by the driver, it should return ENOIOCTLCMD.
>   *
>   *	Optional
> @@ -167,12 +167,12 @@
>   * 
>   * void (*hangup)(struct tty_struct *tty);
>   *
> - * 	This routine notifies the tty driver that it should hangup the
> + * 	This routine notifies the tty driver that it should hang up the
>   * 	tty device.
>   *
>   *	Optional:
>   *
> - * int (*break_ctl)(struct tty_stuct *tty, int state);
> + * int (*break_ctl)(struct tty_struct *tty, int state);
>   *
>   * 	This optional routine requests the tty driver to turn on or
>   * 	off BREAK status on the RS-232 port.  If state is -1,
> @@ -348,7 +348,7 @@ static inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
>   * 	overruns, either.)
>   *
>   * TTY_DRIVER_DYNAMIC_DEV --- if set, the individual tty devices need
> - *	to be registered with a call to tty_register_driver() when the
> + *	to be registered with a call to tty_register_device() when the
>   *	device is found in the system and unregistered with a call to
>   *	tty_unregister_device() so the devices will be show up
>   *	properly in sysfs.  If not set, driver->num entries will be


-- 
js
suse labs
