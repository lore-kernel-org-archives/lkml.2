Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0FCWjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 18:39:11 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58540 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab0FCWjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 18:39:09 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 18:39:09 EDT
Date: Fri, 4 Jun 2010 00:32:59 +0200
From: Andreas Mohr <andi@lisas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
Message-ID: <20100603223259.GA4085@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I do wonder a bit why you even care. You can't even buy non-USB floppy 
> drives any more (and even the USB ones are really really hard to find), 
> and judging by my experiences, they don't last long enough for there to
> be much of a legacy base.

http://such001.reichelt.de/?SID=31BKCyV6wQAR8AAHJNE7U6761b7ea498b06ffe19b1e0abcdc120b;ACTION=444
http://www.kmelektronik.de/shop/index.php?show=subgroup&group=53&subgroup=117&Sort=2
http://www.arlt.com/index.php?cl=search&searchparam=floppy

Up to 10 items each, beige, black, USB, silver, which would you want?
And those are not some shops selling shady rotten scrap hardware...
(rather, these are 3 tests I launched, with a hit rate of 3 out of 3).

OK, a cheap shot certainly, but that's just to show that one's opinion
of what hardware to make use of pretty much never is universal.

Plus I'm certain that some (forensics) folks would appreciate a floppy
driver that remains in semi-working state even in newer (i.e., current)
kernel versions in some decades, since that widens the narrow window
of often conflicting version compatibility and software
that those people will probably encounter
(with their 3 to 5 system environment emulators stacked on top of each other ;)
in their rather progressed times...

</rant>,

Andreas Mohr
