Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1AVMVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 07:21:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38308 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1AVMVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 07:21:15 -0500
Date: Sat, 22 Jan 2011 12:20:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pekka Enberg <penberg@kernel.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dima Zavin <dmitriyz@google.com>, Joe Perches <joe@perches.com>,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Nexus One Support
Message-ID: <20110122122018.GC5194@n2100.arm.linux.org.uk>
References: <20110121094827.41818a55@jbarnes-desktop> <20110121095658.1ab623fe@jbarnes-desktop> <1295632828.19880.22.camel@m0nster> <20110121100441.06a94482@jbarnes-desktop> <1295633882.19880.31.camel@m0nster> <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com> <1295642995.19880.42.camel@m0nster> <1295643762.25868.31.camel@Joe-Laptop> <1295645098.22882.1.camel@m0nster> <AANLkTi=mvdfpCPefGeDr+eGxpSUr3is5jgugHtgB-m1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=mvdfpCPefGeDr+eGxpSUr3is5jgugHtgB-m1w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 01:18:54PM +0200, Pekka Enberg wrote:
> Why is that? I don't see any technical problem of upstreaming the
> original patches even if they don't compile (as long as they're not
> included in Makefiles or Kconfig files). There's no need to hide the
> real history even if it looks ugly...

I've asked Daniel in private whether he'd mind posting the original
set of patches which he based his work on to this thread.

I suspect that the situation is that there's many patches which he's
taken from the repository and consolidated them down into a nice set
of easy to review patches.

One of the problems of preserving the micro-detail of history right
from the early inception of support for a platform is that quite often
the early support is buggy or broken - it might not even compile.  There
may be 20 or so patches on top of that which eventually get it to a
usable state.

Do we really want to put off people from reviewing patches because of
the size of micro-development that happened prior to getting to a point
where the result of that development is usable?

Tell me this: does a patch which cleanly adds support for board X get
reviewed by more, the same, or less people than a set of twenty patches
which goes about the same thing, adding code, removing previously added
code, changing it again.

I personally _hate_ patch sets which do that, and I tend to ignore them
(or maybe review the first twenty patches before taking a break... and
then never going back to them) because I quickly get tired reading all
that code - which means I'm not able to do an effective review.  I
suspect most people suffer from reviewer tiredness when faced with large
patch sets changing the same code time and time again.

I personally believe that Daniel is doing the right thing here, except
he needs to preserve a better record of authorship.  I even think it's
fine if he decides to drop people's sign-offs if he thinks the code has
changed significantly from the original authors - provided he's willing
to take responsibility for the submission of that code.

If you read what a sign-off means (the DCO) then it's clear that if the
code has changed significantly, the original sign-offs do not apply
anymore - the original sign-offs can't warrant that the modified code
is covered by appropriate licenses or even that the person who modified
their code has the rights to submit it.

Take a moment to think about that.  If I took some of your code with
your sign-off, changed it significantly by including someone elses work
where there were no rights to submit that persons work into mainline,
and I kept your sign-off on that, would you be happy when someone starts
making accusations against you submitting their code?

The sign-offs make no representation of who was the author.  In many
cases where companies are involved, the first sign-off is the person
who authorized the release of the code, not the person who wrote the
code, so it's a complete mistake to attribute authorship by whoever was
listed first in the Sign-off lines.  Authorship may be jointly held by
the first 4 people listed, and attributing authorship to only the first
is just as bad as not attributing authorship at all.

Lastly, from the arguments being made over this, if they are supported,
I think that people are saying that the actions listed in DCO (b) are
no longer allowed, and so DCO (b) should be removed entirely as an
acceptable practice.  IOW, what's being promoted as "you must do" (iow,
preserving all history) is completely contary to the allowances of
DCO (b).
