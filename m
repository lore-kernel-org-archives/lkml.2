Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1IVXFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:05:20 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53032 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659Ab1IVXFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:05:17 -0400
X-Sasl-enc: MYhcd00dfuEnkKZVc6rHTTBWUYpOOeTmZ8JY08tgltY4 1316732716
Date: Thu, 22 Sep 2011 16:04:20 -0700
From: Greg KH <greg@kroah.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jesper Juhl <jj@chaosbits.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Kosina <jkosina@suse.cz>, linuxppc-dev@lists.ozlabs.org,
        linux-serial@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        uclinux-dist-devel@blackfin.uclinux.org, linux-cris-kernel@axis.com
Subject: Re: [PATCH 54/62] TTY: irq: Remove IRQF_DISABLED
Message-ID: <20110922230420.GA11264@kroah.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-55-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315383059-3673-55-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 04:10:51PM +0800, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Acked-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  drivers/tty/amiserial.c              |    2 +-
>  drivers/tty/cyclades.c               |    2 +-
>  drivers/tty/hvc/hvc_irq.c            |    2 +-
>  drivers/tty/hvc/hvcs.c               |    2 +-
>  drivers/tty/hvc/hvsi.c               |    2 +-
>  drivers/tty/isicom.c                 |    2 +-
>  drivers/tty/serial/68328serial.c     |    2 +-
>  drivers/tty/serial/altera_jtaguart.c |    2 +-
>  drivers/tty/serial/altera_uart.c     |    2 +-
>  drivers/tty/serial/bfin_5xx.c        |    8 ++++----

This file isn't in my tree anymore, so I can't apply this :(

