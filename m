Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0JSQUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:20:17 -0400
Received: from kroah.org ([198.145.64.141]:34834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab0JSQUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:20:14 -0400
Date: Tue, 19 Oct 2010 09:10:52 -0700
From: Greg KH <greg@kroah.com>
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de, Dinh.Nguyen@freescale.com, leoli@freescale.com,
        dbrownell@users.sourceforge.net, gregkh@suse.de,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mxc_udc: add workaround for ENGcm09152 for i.MX35
Message-ID: <20101019161052.GD20964@kroah.com>
References: <1287145858-10239-1-git-send-email-eric@eukrea.com>
 <20101015191005.GB8098@kroah.com>
 <4CB8AA76.2020309@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CB8AA76.2020309@eukrea.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 09:24:38PM +0200, Eric Bénard wrote:
> Hi Greg,
> 
> Le 15/10/2010 21:10, Greg KH a écrit :
> >On Fri, Oct 15, 2010 at 02:30:58PM +0200, Eric Bénard wrote:
> >>this patch gives the possibility to workaround bug ENGcm09152
> >>on i.MX35 when the hardware workaround is also implemented on
> >>the board.
> >>It covers the workaround described on page 25 of the following Errata :
> >>http://cache.freescale.com/files/dsp/doc/errata/IMX35CE.pdf
> >>
> >>Signed-off-by: Eric Bénard<eric@eukrea.com>
> >>---
> >>  arch/arm/mach-mx3/mach-cpuimx35.c |    1 +
> >>  drivers/usb/gadget/fsl_mxc_udc.c  |   15 +++++++++++++++
> >>  include/linux/fsl_devices.h       |    3 +++
> >>  3 files changed, 19 insertions(+), 0 deletions(-)
> >
> >Do you want me to take this through my usb tree, or will it go through
> >some other developer's tree?
> >
> as most of the changes are in drivers/usb that would be great if you can take it.

No problem, now queued up.

greg k-h
