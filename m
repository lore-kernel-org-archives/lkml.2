Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1FJKDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:03:42 -0400
Received: from vostochny.stro.at ([78.47.22.85]:57933 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab1FJKDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:03:41 -0400
Date: Fri, 10 Jun 2011 10:03:39 +0000
From: maximilian attems <max@stro.at>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild fixes for 3.0
Message-ID: <20110610100339.GE22466@vostochny.stro.at>
References: <20110609214241.GA4849@sepie.suse.cz>
 <BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
 <BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com>
 <BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
 <BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com>
 <BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
 <BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com>
 <BANLkTinZGuOE3G5Ro0=LB9Y8wcHVgk-3ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinZGuOE3G5Ro0=LB9Y8wcHVgk-3ug@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 10:53:34PM -0700, Ray Lee wrote:
> On Thu, Jun 9, 2011 at 10:16 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > Beside that, no matter what, you are about to break
> > `/usr/sbin/sensors-detect' (from my Fedora 14), which rely on a 3
> > digits version number:
> 
> Is there really any compelling technical reason to _not_ have Linus
> release the kernels with a superfluous .0 on the end, with the
> understanding that the -stable team gets to increment it for their
> future releases? It'd make every kernel.org release exactly three
> dotted decimals from here on out, which certainly simplifies things.
> 
> It seems like we're just borrowing trouble here by trying to drop it
> down to two numbers.
> 
> (Not, mind you, that I give a damn at all one way or the other, but it
> feels like you all are going to be spending a lot of time tripping
> over poor assumptions in userspace rather than doing actual work.)

you have forgotten the rule that linus himself is allowed to break userland. :P

in Debian an three digit 3.0.0 release would also be very much appreciated as
dpkg will order wrongly 3.0.0~rcX to 3.0.

-- 
maks
