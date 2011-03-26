Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1CZTM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 15:12:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:42740 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab1CZTM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 15:12:26 -0400
Date: Sat, 26 Mar 2011 20:12:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT pull] irq cleanups for .39
In-Reply-To: <AANLkTimZRRwRQMHn7dtVW-JDqgCxxzLgbtJJUk4b41wW@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103262010590.31464@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103251747450.31464@localhost6.localdomain6> <20110325194010.GG22960@elte.hu> <AANLkTimZRRwRQMHn7dtVW-JDqgCxxzLgbtJJUk4b41wW@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1066172291-1301166741=:31464"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1066172291-1301166741=:31464
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 26 Mar 2011, richard -rw- weinberger wrote:
> On Fri, Mar 25, 2011 at 8:40 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> >> Linus,
> >>
> >> Please pull the latest irq-cleanup-for-linus git tree from:
> >>
> >>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-cleanup-for-linus
> >>
> >> This contains the irq/urgent bits which Ingo asked to pull earlier, so
> >> whatever you pull first does not matter.
> >>
> >> The gpio patches have been acked by Grant.
> >>
> >> The avr, h8300, xtensa, m32r, um bits is stuff which got ignored by
> >> the arch maintainers. Those archs seem to be orphaned.
> >>
> >> The cleanup is necessary as we really want to get rid of all the
> >> deprecated and compat stuff asap.
> >
> > Note, while the architectures are orphaned, i've done cross-build testing for
> > most of these architectures with your changes applies, so the ones that built
> > before should still work now.
> 
> um really seems to be orphaned. Jeff has never responded to my emails.
> As I'm a heavy user of User Mode Linux I keep it alive on my own.
> 
> Please send patches which require action on UML to me or CC
> user-mode-linux-devel@lists.sourceforge.net so that I can pick up and test them.
> I have a testbed for UML.

Could you please send a patch which adds your mail address and the ML
to the maintainers file ?

Thanks,

	tglx


---1463795968-1066172291-1301166741=:31464--
