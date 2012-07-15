Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2GOV6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 17:58:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40694 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab2GOV6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 17:58:51 -0400
Date: Sun, 15 Jul 2012 23:58:53 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paulo Marques <pmarques@grupopie.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Jan Beulich <jbeulich@novell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "Inconsistent kallsyms data" error
Message-ID: <20120715215853.GA11632@glitch>
Mail-Followup-To: Paul Gortmaker <paul.gortmaker@windriver.com>,
	Paulo Marques <pmarques@grupopie.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
	Arnaud Lacombe <lacombar@gmail.com>,
	Nick Bowler <nbowler@elliptictech.com>,
	Jan Beulich <jbeulich@novell.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFyr+gexQW9Gmg=_V145SUeKOcfSNUx5h4p7bgjMp=07Og@mail.gmail.com>
 <4FF6C958.9090809@grupopie.com>
 <CAP=VYLqCNDo+3tz2RibPwwCNUNNYf1WA+wmeeUor8AmJqnfz1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP=VYLqCNDo+3tz2RibPwwCNUNNYf1WA+wmeeUor8AmJqnfz1A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 12:48:23AM -0400, Paul Gortmaker wrote:
> On Fri, Jul 6, 2012 at 7:17 AM, Paulo Marques <pmarques@grupopie.com> wrote:
> 
> [...]
> 
> >
> > There was a recent thread from David Brown on the arm linux mailing list
> > ("ARM: two possible fixes for the KALLSYMS build problem"). He tracked
> > down the problem to having empty per_cpu sections on a non-smp build.
> 
> Actually rmk diagnosed it as the empty per_cpu sections.  See it here:
> 
> http://marc.info/?l=linux-next&m=133267456809502&w=2

I also saw this problem in the past (a couple of months ago), mostly on a
specific machine. But I _am_ playing with the linker scripts so I expected
to be the cause in an unknown way.

Unfortunately I've never understood the cause (I also switched from reiserfs
to ext4 in the panic, moving the source tree around seemed to help). The
behaviour seemed inconsistent and could not reliably reproduce it even if
there were very few "moving targets". Very clueless.

Don't know why I'm not encountering it any more but a more useful diagnostic
would be surely useful.  The second pass thing didn't help me either. I
also tried to implement an addition pass but the thing was not making any
sense to me anyway.

So yes, in case of error please leave some trace somewhere so that to poor
user has some chance to work his/her good luck out of the troubles.

cheers,
Domenico
