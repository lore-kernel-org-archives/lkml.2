Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1GEPXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:23:09 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52275 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148Ab1GEPXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:23:07 -0400
X-Sasl-enc: s2t4b65OVNz0Dqi0XQ31Vcf0mcjgFrjoYeTgT84ljf/x 1309879386
Date: Tue, 5 Jul 2011 08:23:02 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/49] GMA50 series update
Message-ID: <20110705152302.GA30891@kroah.com>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 03:33:48PM +0100, Alan Cox wrote:
> (Rebased versus the patches Greg took earlier)
> 
> The main things here are modularisation and support for Cedarview (this is
> unaccelerated as it has no 2D acceleration). I have some crazy ideas about using
> the GTT to do 2D console acceleration however but not much can be done for X.
> 
> At this point I think the Poulsbo (GMA500) and Cedarview code are probably ready
> to move out of staging - hence the modularisation work. The MID platforms need
> more cleaning up.
> 
> HDMI support at this point is pretty basic with no HDMI audio support. I'm hoping
> that will be something that can be addressed in future and now the basic bits
> are there I need to take a look at Oaktrail (Atom Z760/GMA600) and see if the
> same code can be used to bring up HDMI on that device too.

I've applied this series, but I get the following error when building:

make[2]: *** No rule to make target `drivers/staging/gma500/cdv_intel_crt.o', needed by `drivers/staging/gma500/psb_gfx.o'.  Stop.

Care to send a follow-on patch fixing this?

Also, should I be able to select all of the different platforms even
though I'm only building for a x86-64 platform?

thanks,

greg k-h
