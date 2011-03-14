Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1CNNQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:16:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34350 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753535Ab1CNNQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:16:27 -0400
Cc: Jan Beulich <JBeulich@novell.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        binutils@sourceware.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Date: Mon, 14 Mar 2011 14:16:23 +0100
From: "Ralf Wildenhues" <Ralf.Wildenhues@gmx.de>
In-Reply-To: <20110314122342.GA26825@elte.hu>
Message-ID: <20110314131623.119020@gmx.net>
MIME-Version: 1.0
Organization: Institute for Numerical Simulation, University of Bonn
References: <20110311165802.GA3508@intel.com>
 <4D7A64670200007800035F4C@vpn.id2.novell.com>
 <AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
 <4D7DE39302000078000362E6@vpn.id2.novell.com>
 <20110314095534.GB18058@elte.hu>
 <20110314104131.GG6275@bubble.grove.modra.org> <20110314122342.GA26825@elte.hu>
Subject: git bisect plus fixes (was: PATCH: Add --size-check=[error|warning])
To: Ingo Molnar <mingo@elte.hu>, git@vger.kernel.org
X-Authenticated: #13673931
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Mutt-Fcc: =git
X-Mutt-References: <20110314122342.GA26825@elte.hu>
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+86LdEcsC83AfpL64lSuTjzb+WnFcD5/aFJg5ZfI
 Tbw8HrecaezDupFW31Ot3CowzX5X5aYFk+/g== 
X-GMX-UID: RnkVJTd7TlI8TqPAp2hrBBZOU2poZZne
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding the git list; this is
  http://thread.gmane.org/gmane.comp.gnu.binutils/52601/focus=1112779 ]

Hello,

* Ingo Molnar wrote on Mon, Mar 14, 2011 at 01:23:42PM CET:
> Also, i hope you are not suggesting to break projects just because
> they are not important to you personally? The fix is exceedingly
> simple to do for the binutils project - and impossible to do for the
> kernel project (because during bisection - which is a very powerful
> debugging tool - older versions of the source get checked out).

FWIW, I don't have an opinion on this particular binutils issue, but
it would be very helpful if 'git bisect' made it easy to denote
"when going back, you might also need some of these changes".
(I'd just use a patch -p1 with a here-file in the bisect script, but
that might not be enough for all practical use cases.)

This issue has come up several times with high-profile issues.

Thanks,
Ralf
