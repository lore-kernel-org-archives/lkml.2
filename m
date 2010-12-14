Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab0LNAm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:42:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:56885 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757662Ab0LNAm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:42:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,339,1288594800"; 
   d="scan'208";a="361213873"
Date: Mon, 13 Dec 2010 16:42:08 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Mark Brown <broonie@sirena.org.uk>, Matthias Schniedermeyer <ms@citd.de>,
        Luben Tuikov <ltuikov@yahoo.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
Message-ID: <20101214004208.GA25538@xanatos>
References: <20101213194841.GA20997@citd.de>
 <20101213215324.GA6565@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213215324.GA6565@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 10:53:25PM +0100, Andreas Mohr wrote:
> I was just chilling down late in the evening by reading a short LKML 
> overview, and then inadvertently managed to hit this bomb shell ;)
> 
> > As uas has not been in a release-kernel, by definition, there is no 
> > impact either way. No regressions or anything else.
> 
> Since I've actually just been oldconfig'ing uas driver yesterday on a new 
> installation, I can relate to UAS kernel support being quite new 
> in its entirety.
> 
> If this is the case, then I'd also tend to believe the situation
> is very different from other more painful (since longstanding) driver conflicts
> (e.g. 8139, some raid drivers, and also e100 as witnessed by myself).
> 
> The author of UASP might want to adjust some of his writings
> (especially the more personal parts),
> however several parts of his criticism (e.g. no focus on code review)
> seem valid from my POV.

I think you may be missing some code review on the linux-usb mailing
list.  Luben posted his original patch to the uas.c driver there, but he
included behavior changes, code style modification, and variable
renaming in one giant patch.  It was very difficult to wade through, so
I asked him to break the changes into a series of patches (perhaps 18,
since he has 18 points?).

I did attempt to give a partial code review of Luben's original patches,
and he has yet to respond to any of my points:

http://marc.info/?l=linux-kernel&m=129021816023869&w=2

I also asked him to change a different patch for his driver, to move a
work-around into a better place:

http://marc.info/?l=linux-kernel&m=129192831709856&w=2

I have yet to see an updated patch set, only personal attacks.

Sarah Sharp
