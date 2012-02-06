Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2BFREM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:04:12 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59037 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755596Ab2BFREG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:04:06 -0500
X-Sasl-enc: /vWvMAjPmm96/vOd6iUySU+li8oa95QRqAoyGZ/rpsWl 1328547845
Date: Mon, 6 Feb 2012 08:54:47 -0800
From: Greg KH <gregkh@linuxfoundtion.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Ambroz Bizjak <ambrop7@gmail.com>, nico@fluxnic.net, tzachi@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: USB regression on TS-7800 board
Message-ID: <20120206165447.GA13710@kroah.com>
References: <CAOA3yKLsecBx4aQ1Rvcw-VCa7JO-u-WNhTMdt9s+8trJWwpCeg@mail.gmail.com>
 <20120204105423.GA6693@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120204105423.GA6693@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 11:54:23AM +0100, Andrew Lunn wrote:
> On Sat, Feb 04, 2012 at 02:27:18AM +0100, Ambroz Bizjak wrote:
> > Hi,
> > 
> > I've had problems with using newer Linux kernels with the TS-7800 ARM
> > board. Since kernel 3.0.0, USB storage devices are not recognized, and
> > errors are reported. See attachments for kernel output.
> 
> Hi Ambroz
> 
> Thanks for the regression report.
> 
> I don't have any Orion5x hardware, i only have kirkwood based
> machines. So its very hard for me to test these changes.
> 
> I've spotted one thing which looks wrong. Please could you test
> this. Its not a fix, just a proof i'm on the right track.
> 
> In arch/arm/plat-orion/common.c

Care to tag this patch for the stable tree when you submit it for
inclusion so that older trees get this fix?

thanks,

greg k-h
