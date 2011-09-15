Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1IOKRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:17:24 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54226 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946Ab1IOKRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:17:23 -0400
X-Sasl-enc: D8dxbojcWsJmd3hdaYvoLrsCnl/VcmO9y4scIdNv0I3L 1316081842
Date: Thu, 15 Sep 2011 12:16:43 +0200
From: Greg KH <greg@kroah.com>
To: Leopold Palomo-Avellaneda <leo@alaxarxa.net>
Cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        630593@bugs.debian.org, Nicos Gollan <gollan@informatik.uni-kl.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH/RFC] parport_pc: remove ancient, overeager quirk that
 disables EPP support on many chipsets
Message-ID: <20110915101643.GA10802@kroah.com>
References: <201109151133.19211.leo@alaxarxa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109151133.19211.leo@alaxarxa.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 11:33:18AM +0200, Leopold Palomo-Avellaneda wrote:
> Hi,
> 
> there's a bug in the parport module that have been reported (in another 
> places) some time ago [1]. Also, this bug was reported at Redhat [2], but 
> nobody follow the report and it was closed.
> 
> As Adam baked said [1] :
> 
> <quote>
> A long time ago (~ 10 years), Intel produced a chipset that 
> included broken EPP support. The Linux parport driver was written to detect 
> such a chipset and disable EPP support on it. Unfortunately the test that was 
> written gives false positives for many current chipsets and no-one seems to 
> know exactly what the problem hardware was, let alone have a sample of it to 
> see if a better test can be written. After such a long time it is probably 
> appropriate to just remove the test (on average it does more harm than good) 
> however you are correct in asserting the driver is unmaintained so no-one is 
> bothering to fix it.
> </quote>
> 
> I have applied the patch to the standard debian kernel and vanilla kernels and 
> runs perfectly. The patch simply erases a check. Applied to some Dell 
> hardware, now the EPP mode is detected and, after some initial tests it's 
> working.
> 
> Please, apply the patch.

Please resend it with the proper Signed-off-by: line, as described by
Documentation/SubmittingPatches and we will be glad to consider it.

thanks,

greg k-h
