Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab1IONga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:36:30 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38650 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933125Ab1IONg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:36:29 -0400
X-Sasl-enc: 9lcp5uQ6I2korbKvI+wxh9oqah8UKGkv3XNCD+zEHSl/ 1316093788
Date: Thu, 15 Sep 2011 15:35:55 +0200
From: Greg KH <greg@kroah.com>
To: Leopold Palomo-Avellaneda <leo@alaxarxa.net>
Cc: linux-kernel@vger.kernel.org, Adam Baker <linux@baker-net.org.uk>,
        linux-parport@lists.infradead.org, 630593@bugs.debian.org,
        Nicos Gollan <gollan@informatik.uni-kl.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH/RFC] parport_pc: remove ancient, overeager quirk that
 disables EPP support on many chipsets
Message-ID: <20110915133555.GB16636@kroah.com>
References: <201109151441.15015.leo@alaxarxa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109151441.15015.leo@alaxarxa.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 02:41:14PM +0200, Leopold Palomo-Avellaneda wrote:
> Hi again,
> 
> sorry for the noise and my mistake. The patch...
> 
> there's a bug in the parport module that have been reported (in another 
> places) some time ago [1]. Also, this bug was reported at Redhat [2], but 
> nobody follow the report and it was closed.
> 
> As Adam Baker said [1] :
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
> 
> Best regards,
> 
> Leo
> 
> [1] http://lists.infradead.org/pipermail/linux-parport/2008-March/000628.html
> [2] https://bugzilla.redhat.com/show_bug.cgi?id=284471
> 
> 
> Signed-off-by: Adam Baker <linux at baker-net.org.uk>

You can not add someone else's signed-off-by: line to a patch, please go
re-read Documentation/SubmittingPatches as to why.

And did Adam originally write this patch?  Or did you?  If Adam, please
set the authorship information properly.

Oh, and please spell out email addresses properly in signed-off-by
lines, it doesn't hide anything when you do that :)

Third time's a charm?

greg k-h
