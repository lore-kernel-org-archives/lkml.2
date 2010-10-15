Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0JOTSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:18:08 -0400
Received: from kroah.org ([198.145.64.141]:47450 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377Ab0JOTSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:18:02 -0400
Date: Fri, 15 Oct 2010 12:10:05 -0700
From: Greg KH <greg@kroah.com>
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de, Dinh.Nguyen@freescale.com, leoli@freescale.com,
        dbrownell@users.sourceforge.net, gregkh@suse.de,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mxc_udc: add workaround for ENGcm09152 for i.MX35
Message-ID: <20101015191005.GB8098@kroah.com>
References: <1287145858-10239-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287145858-10239-1-git-send-email-eric@eukrea.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 02:30:58PM +0200, Eric Bénard wrote:
> this patch gives the possibility to workaround bug ENGcm09152
> on i.MX35 when the hardware workaround is also implemented on
> the board.
> It covers the workaround described on page 25 of the following Errata :
> http://cache.freescale.com/files/dsp/doc/errata/IMX35CE.pdf 
> 
> Signed-off-by: Eric Bénard <eric@eukrea.com>
> ---
>  arch/arm/mach-mx3/mach-cpuimx35.c |    1 +
>  drivers/usb/gadget/fsl_mxc_udc.c  |   15 +++++++++++++++
>  include/linux/fsl_devices.h       |    3 +++
>  3 files changed, 19 insertions(+), 0 deletions(-)

Do you want me to take this through my usb tree, or will it go through
some other developer's tree?

Either is fine with me.

thanks,

greg k-h
