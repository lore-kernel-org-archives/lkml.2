Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2FXQDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 12:03:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42333 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2FXQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 12:03:34 -0400
Date: Sun, 24 Jun 2012 17:06:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rob Landley <rob@landley.net>
Cc: daniel.santos@pobox.com, Daniel Santos <danielfsantos@att.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v4 0/13] Generic Red-Black Trees
Message-ID: <20120624170607.1584c278@pyramind.ukuu.org.uk>
In-Reply-To: <4FE69A14.6040904@landley.net>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
	<4FE64AB4.1010904@landley.net>
	<4FE661F8.3000109@att.net>
	<4FE69A14.6040904@landley.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Forgive me, but I'm a little stumped here.  When did GCC move to a
> > "non-open" license?

It didn't

> About when it decided anti-tivoization was within its mandate, so

A lot of consider the GPLv2 license has the same requirement

> That said, reducing code duplication is a good thing. I'm just not
> convinced "how well gcc 4.6 optimizes this" is the only relevant test
> criteria here.

It is for the other 99.999999999% of users.

> LLVM/CLANG is bsd licensed (alas, with advertising clause, but code from
> it might actually be incorporatable into the linux kernel, unlke gcc,
> which is under a license extensively incompatible with the linux kernel).

Advertising clause BSD is not GPL compatible.

> Ok, so "designed with gcc 4.6's optimizer in mind, regression tested
> back to 3.4 for at least minimal functionality, and not intentionally
> breaking other compilers".

If you want it to work with weird cornercase compilers its for your
benefit so it's your problem and you do the work. Thats how free software
works. At the point lots of people starting using your compiler it might
matter more and if everyone starts using your compiler then it'll end up
being the primary optimisation target.

Alan
