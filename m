Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934885Ab1IOU3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:29:33 -0400
Received: from honeysuckle.london.02.net ([87.194.255.144]:50459 "EHLO
	honeysuckle.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934640Ab1IOU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:29:32 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Sep 2011 16:29:32 EDT
From: Adam Baker <linux@baker-net.org.uk>
To: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH/RFC] parport_pc: remove ancient, overeager quirk that disables EPP support on many chipsets
Date: Thu, 15 Sep 2011 21:23:06 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.6.2; i686; ; )
Cc: Greg KH <greg@kroah.com>, "Leopold Palomo-Avellaneda" <leo@alaxarxa.net>,
        linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        630593@bugs.debian.org, Nicos Gollan <gollan@informatik.uni-kl.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
References: <201109151441.15015.leo@alaxarxa.net> <20110915133555.GB16636@kroah.com> <20110915173950.GA19450@elie>
In-Reply-To: <20110915173950.GA19450@elie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109152123.07678.linux@baker-net.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 September 2011, Jonathan Nieder wrote:
> Hi,
> 
> Greg KH wrote:
> > You can not add someone else's signed-off-by: line to a patch, please go
> > re-read Documentation/SubmittingPatches as to why.
> > 
> > And did Adam originally write this patch?  Or did you?  If Adam, please
> > set the authorship information properly.
> 
> From a quick Google search:
> 
> http://lists.infradead.org/pipermail/linux-parport/2008-March/000628.html
> 
> It looks like this one does have Adam Baker's sign-off (and it is sad
> how long this patch seems to have sat without being submitted to
> mainline).

The code has sat around for a long time because when I first posted the patch 
I got no feedback to indicate if anyone else was suffering from the bug and if 
anyone else had hardware that exhibited the bug it was supposed to fix so I 
didn't want to pursue submitting it. Over the years I have seen occasional 
reports of users suffering from the problem but I no longer have any EPP 
hardware to test it on.

That's why I posted the mail that said if someone else can verify the patch is 
still useful I'm happy for it to be submitted with my signed off by on it (and 
the original mail did use an @ sign, the word at got added by an email 
obfuscator in a mailing list archive along the way.)

> 
> I don't know who originally had the idea of removing that code.  See
> [1], [2], [3], and [4] for some early discussions.
> 
> The current "intel parport bug" test this patch removes seems to have
> been introduced between 2.3.10pre5 and 2.3.10 (thanks to Dave Jones
> for the git tree that makes such searches easy!).  That means some
> time around June or July, 1999.  At the time, the parport maintainers
> according to MAINTAINERS were Phil Blundell, Tim Waugh, David
> Campbell, and Andrea Arcangeli.  From the patch "[PATCH] parport is an
> orphan", 2007-03-05, I infer that not all of them are still interested
> in the driver and whoever _is_ interested is probably subscribed to
> the (low-volume) linux-parport list.
> 
> I'd say, why not get this patch in linux-next or -mm somehow and see
> if anyone screams?  It would be _very_ useful to find an actual
> instance of the "intel parport bug" so we could see what that code was
> supposed to do and do it better.
> 
> Thanks,
> Jonathan
> 
> [1] http://thread.gmane.org/gmane.linux.parport/322/focus=326
> [2] http://thread.gmane.org/gmane.linux.parport/324/focus=327
> [3] http://thread.gmane.org/gmane.linux.parport/806
> [4] http://thread.gmane.org/gmane.linux.parport/925/focus=929

