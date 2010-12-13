Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab0LMVxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:53:40 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50540 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab0LMVx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:53:26 -0500
Date: Mon, 13 Dec 2010 22:53:25 +0100
From: Andreas Mohr <andi@lisas.de>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Matthias Schniedermeyer <ms@citd.de>, Luben Tuikov <ltuikov@yahoo.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
Message-ID: <20101213215324.GA6565@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213194841.GA20997@citd.de>
X-Priority: none
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was just chilling down late in the evening by reading a short LKML 
overview, and then inadvertently managed to hit this bomb shell ;)

> As uas has not been in a release-kernel, by definition, there is no 
> impact either way. No regressions or anything else.

Since I've actually just been oldconfig'ing uas driver yesterday on a new 
installation, I can relate to UAS kernel support being quite new 
in its entirety.

If this is the case, then I'd also tend to believe the situation
is very different from other more painful (since longstanding) driver conflicts
(e.g. 8139, some raid drivers, and also e100 as witnessed by myself).

The author of UASP might want to adjust some of his writings
(especially the more personal parts),
however several parts of his criticism (e.g. no focus on code review)
seem valid from my POV.

If the new driver indeed is a whole lot better than the other newly
submitted/unreleased driver, then I'd fully welcome a reevaluation of the
situation.

For the author of the original submission this might of course be a
"less than positive" (to put it extreemely mildly) situation.
Still, I'd hope that there could be sufficient agreement on how to proceed
and how to make sure to have the most fitting code get into the kernel
and be maintained properly, ideally by continued interest by _both_
authors (or perhaps via "personality firewalls" ;), obviously.

Alas, I'm feeling like I'm stating obvious blathering here.

Anyway, by now you know which direction I'm tending in, despite the
not terribly warm writings by a certain author ;)

Disclaimer: no code review (comparison) performed, sorry.
Disclaimer #2: as the author of a still-outstanding kernel patch
(uhm - hi Greg ;) I'm in a sufficiently unfavourable position to comment
on this...

Andreas Mohr
