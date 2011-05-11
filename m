Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab1EKQTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:19:18 -0400
Received: from kroah.org ([198.145.64.141]:35354 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477Ab1EKQTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:19:02 -0400
Date: Wed, 11 May 2011 06:47:30 -0700
From: Greg KH <greg@kroah.com>
To: Erik Slagter <erik@slagter.name>
Cc: linux-kernel@vger.kernel.org, Maxin John <maxin.john@gmail.com>
Subject: Re: [PATCH 001/001]: USB: cdc_acm: Fix oops when Droids MuIn LCD is
 connected
Message-ID: <20110511134730.GA12717@kroah.com>
References: <20110510074421.GA2755@maxin>
 <4DC97BD0.6040403@slagter.name>
 <BANLkTi=OQ=ahXW2n=ww4ZZ8vK4=mv6Kc7A@mail.gmail.com>
 <4DCA5FBF.1050009@slagter.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCA5FBF.1050009@slagter.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 12:06:55PM +0200, Erik Slagter wrote:
> From: Erik Slagter <erik@slagter.name>
> 
> The Droids MuIn LCD operates like a serial remote terminal.
> Data received are displayed directly on the LCD. This patch
> fixes the kernel null pointer oops when it is plugged in.
> 
> Add NO_DATA_INTERFACE quirk to tell the driver that "control"
> and "data" interfaces are not separated for this device, which
> prevents dereferencing a null pointer in the device probe code.
> 
> Signed-off-by: Erik Slagter <erik@slagter.name>
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> Tested-by: Erik Slagter <erik@slagter.name>
> ---
> This patch applies to vanilla kernel 2.6.38.2, but I am quite
> confident it will apply to any recent kernel. It was created by
> Maxin John after I located the problem, slightly modified by me
> and tested by me, so blame me if it breaks anything.

If Maxin created it, it should have his "From:" on the top, right?

And did Maxin really sign-off-by: on the patch?  You can not add other
people's names to that without them really doing it, that's not allowed
at all.

Care to redo it?

thanks,

greg k-h
