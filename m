Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965285Ab1JFR6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:58:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49279 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1JFR6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:58:10 -0400
Date: Thu, 6 Oct 2011 19:58:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        rdunlap@xenotime.net, axboe@kernel.dk, akpm@linux-foundation.org,
        neilb@suse.de
Subject: Re: [GIT] Bcache version 12
Message-ID: <20111006175808.GA9886@atrey.karlin.mff.cuni.cz>
References: <20110910064531.GA32536@moria> <CAOJsxLFPODubVEB3Tjg54C7jDKM8H-RCM_u5kvO1D0kKyjUYXQ@mail.gmail.com> <20110921025545.GB5521@moria> <CAOJsxLHQdf-+HuwVsQtF26oY_oJf3BsVdDi3NyJDi7F0eD03Gw@mail.gmail.com> <CAOJsxLGWoGqdv=tdBwWjM9-MD_Qm3ibMSGpp1j-tQLjMW-b-0A@mail.gmail.com> <20110921055708.GB6601@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921055708.GB6601@moria>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> It can cache filesystem metadata - it can cache anything.
> 
> Because bcache has its own superblock (much like md), it can guarantee
> that bcache devices are consistent; this is particularly important if
> you want to do writeback caching. You really don't want to accidently
> mount a filesystem that you were doing writeback caching on without the
> ache - bcache makes it impossible to do so accidently.
> 
> Is any of that useful?

I guess some kind of benchmark would be nice....? I don't know what
fair workload for this is. System bootup? Kernel compile after reboot?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
