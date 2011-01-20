Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1ATHxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 02:53:46 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:37039 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761Ab1ATHxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:53:45 -0500
Date: Thu, 20 Jan 2011 09:53:36 +0200
From: Felipe Balbi <balbi@ti.com>
To: ahern.michael.t@gmail.com
Cc: gregkh@suse.de, u.kleine-koenig@pengutronix.de, julia@diku.dk,
        nikai@nikai.net, morgan.gatti@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Coding style in serial2002
Message-ID: <20110120075336.GA5888@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1295509802-18042-1-git-send-email-ahern.michael.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295509802-18042-1-git-send-email-ahern.michael.t@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 06:50:02PM +1100, ahern.michael.t@gmail.com wrote:
> From: Michael Ahern <ahern.michael.t@gmail.com>
> 
> This patch resolves braces and KERN_ warnings by checkpatch.pl
> Warnings: printk() should include KERN_ facility level, removed unnecessary braces, lines over 80 chars

break the commit log in 72 chars

> @@ -246,7 +246,12 @@ static void tty_setspeed(struct file *f, int speed)
>  		struct termios settings;
>  
>  		tty_ioctl(f, TCGETS, (unsigned long)&settings);
> -/* printk("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX)); */
> +
> +		/* printk("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX));
> +		 * better
> +		 * pr_info("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX));
> +		 */

since you're fixing coding style, you might as well use the correct
multi-line comment style:

/*
 * printk(....
 * better
 * pr_info(....
 */

-- 
balbi
