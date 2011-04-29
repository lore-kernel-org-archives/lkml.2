Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717Ab1D2RnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:43:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:49772 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760577Ab1D2RnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:43:02 -0400
Date: Fri, 29 Apr 2011 19:42:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@linux.intel.com>
cc: Pekka Enberg <penberg@kernel.org>, Vince Weaver <vweaver1@eecs.utk.edu>,
        torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
In-Reply-To: <20110429172525.GA2745@tassilo.jf.intel.com>
Message-ID: <alpine.LFD.2.02.1104291938240.3005@ionos>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu> <BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com> <20110429172525.GA2745@tassilo.jf.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1564882551-1304098974=:3005"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1564882551-1304098974=:3005
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 29 Apr 2011, Andi Kleen wrote:

> > >  2.  Users are too stupid to use the raw functionality properly;
> > >      we should only allow a kernel-developer-approved small subset
> > >      of the features provided by the CPU as described in the intel
> > >      developers manuals.
> > >
> > > #2 seems like a gross misinterpretation of the whole "Linux gives you
> > > enough rope to shoot yourself in the foot" policy from days passed, but
> > > maybe things have moved on.
> > 
> > That's a gross misrepresentation of what Ingo has been saying on LKML.
> > Really, learn to work with relevant maintainers before you ask Linus
> > to revert something.
> 
> Ingo may not have explicitely said (2), but at least his revert (disabling
> the raw interface users are asking for) is practically implementing (2).
> 
> Actions speak louder than words.
> 
> That is either you have a raw interface or you only have the cooked
> interface or you have both. Since he reverted raw only cooked
> is left, which is (2)
> 
> I agree with Vince it's a bad policy.

No, it's not the raw interface will be made available when the proper
set of abstracted functionality has been added and settled down,
simply because it might to change the way the raw event is exposed. As
long there are open questions which might have an influence on the
exposure of the raw event, it's completely correct to keep it
disabled.

Though you and Vince ignored Peters patches and the questions he
raised and just kept harping on your own interests.

That's a bad attitude, but we've been there before.

Thanks,

	tglx
--8323328-1564882551-1304098974=:3005--
