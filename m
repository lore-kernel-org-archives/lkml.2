Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333Ab1D2RZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:25:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:52615 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759771Ab1D2RZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:25:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,288,1301900400"; 
   d="scan'208";a="427905675"
Date: Fri, 29 Apr 2011 10:25:25 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, torvalds@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110429172525.GA2745@tassilo.jf.intel.com>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
 <BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  2.  Users are too stupid to use the raw functionality properly;
> >      we should only allow a kernel-developer-approved small subset
> >      of the features provided by the CPU as described in the intel
> >      developers manuals.
> >
> > #2 seems like a gross misinterpretation of the whole "Linux gives you
> > enough rope to shoot yourself in the foot" policy from days passed, but
> > maybe things have moved on.
> 
> That's a gross misrepresentation of what Ingo has been saying on LKML.
> Really, learn to work with relevant maintainers before you ask Linus
> to revert something.

Ingo may not have explicitely said (2), but at least his revert (disabling
the raw interface users are asking for) is practically implementing (2).

Actions speak louder than words.

That is either you have a raw interface or you only have the cooked
interface or you have both. Since he reverted raw only cooked
is left, which is (2)

I agree with Vince it's a bad policy.

-Andi

