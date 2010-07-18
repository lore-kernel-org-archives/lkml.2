Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab0GRHQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 03:16:13 -0400
Received: from THUNK.ORG ([69.25.196.29]:39947 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab0GRHQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 03:16:10 -0400
Date: Sun, 18 Jul 2010 03:15:52 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Dimitrios Apostolou <jimis@gmx.net>,
        linux-kernel@vger.kernel.org, Dan Nicolaescu <dann@gnu.org>
Subject: Re: emacs and "linux" coding style
Message-ID: <20100718071552.GB4684@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Dimitrios Apostolou <jimis@gmx.net>, linux-kernel@vger.kernel.org,
	Dan Nicolaescu <dann@gnu.org>
References: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain>
 <m3tyny31mo.fsf@intrepid.localdomain>
 <20100717065146.732f5449.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100717065146.732f5449.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 17, 2010 at 06:51:46AM -0700, Randy Dunlap wrote:
> On Sat, 17 Jul 2010 11:21:03 +0200 Krzysztof Halasa wrote:
> 
> > Dimitrios Apostolou <jimis@gmx.net> writes:
> > 
> > > static void update_group_shares_cpu(struct task_group *tg, int cpu,
> > >                                     unsigned long sd_shares,
> > >                                     unsigned long sd_rq_weight,
> > >                                     unsigned long *usd_rq_weight)
> > > {
> > 
> > From a technical POV the above should not have any tabs, the parameters
> > should be aligned with spaces only.
> 
> fwiw, it seems that you agree with Ted.

Actually, what my code use is tabs with a tab stop of 8 followed by
enough spaces (< 7) to align function parameters and to align
open/close parenthesis in C expression line wrap.

The main problem seems to be that Chapter 9 in
Documentation/CodingStyle is written by someone who feels that since
vi makes it easy to only align parameters using tabs, that everybody
should do it the same way as vi.  I'm simply challenging Chapter 9 as
being canon.  I certainly ignore it, and as a maintainer I tend to
accept either vi or emacs-style indentations with respect to
parameters and C expressions.

						- Ted
