Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab2J3PhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:37:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38634 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2J3Pg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:36:59 -0400
Date: Tue, 30 Oct 2012 16:36:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Sooman Jeong <77smart@hanyang.ac.kr>, linux-kernel@vger.kernel.org
Subject: Re: Initial report on F2FS filesystem performance
Message-ID: <20121030153655.GB12831@xo-6d-61-c0.localdomain>
References: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr>
 <20121020192215.GB555@elf.ucw.cz>
 <E0328919-ACAA-4052-B922-952AFA375FD8@dubeyko.com>
 <20121021102638.GA14031@elf.ucw.cz>
 <1350905803450.1936.166.00.1.77smart@hanyang.ac.kr>
 <20121023000725.GA10990@elf.ucw.cz>
 <54B92072-C95C-404F-A058-CF77098855C4@dubeyko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B92072-C95C-404F-A058-CF77098855C4@dubeyko.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> * buffered write (1GB file), 4KByte write
> > 
> > Ok, f2fs is bit faster on desktop PC and a bit slower on S3. Good.
> > 
> > 
> >> * write + fsync (100MB file), 4KByte write
> > 
> > Ok, random access on VFAT is a lot faster on S3 (and only very
> > a bit on PC). Any idea why results are so different between PC and S3?
> > Does F2FS need significantly more CPU? Does F2FS need significantly
> > more RAM? (Booting PC with low mem= option my answer that).

>  Yes, I think that f2fs really needs more CPU and memory for
> functioning. The f2fs keeps more metadata as VFAT, as I
> understand. Moreover, it manages six active logs at runtime and GC
> can works in background. All of it needs in more CPU power.

Thanks for info.

Out of curiosity, how does F2FS perform on low-end SD cards (compared
to VFAT)? I know Kingstons and similar can have only single group open
for writing... VFAT still works there, does F2FS?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
