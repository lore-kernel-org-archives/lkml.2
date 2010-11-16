Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab0KPFdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 00:33:05 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34403 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752576Ab0KPFdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 00:33:03 -0500
Date: Tue, 16 Nov 2010 06:32:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.37-rc1+: hibernate regression, claims not enough swap space
Message-ID: <20101116053236.GA30605@elf.ucw.cz>
References: <20101114052138.GB2189@elf.ucw.cz>
 <201011152326.44357.rjw@sisk.pl>
 <20101116052634.GA30449@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116052634.GA30449@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-11-16 06:26:34, Pavel Machek wrote:
> Hi!
> 
> > > ...but there's enough -- or at least it was enough to fit previous
> > > versions. 32-bit machine, so it has highmem.
> > > 
> > > System is in console mode, very lightly loaded.
> > > 
> > > Mem:   2054716k total,   736548k used,  1318168k free,    15368k buffers
> > > Swap:   779148k total,     2360k used,   776788k free,   546388k cached
> > 
> > Well, the swap is rather in short supply.  Below the 50% of RAM recommendation.
> 
> Well, but the biggest image we can write is not 50% of RAM, but 50% of
> lowmem... and swap is nearly as big as lowmem in this case -- so this
> machine is not misconfigured.

BTW swsusp.txt may need updating, it says:

echo N > /sys/power/image_size

before suspend (it is limited to 500 MB by default).

...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
