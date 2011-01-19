Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1ASW0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:26:43 -0500
Received: from www.tglx.de ([62.245.132.106]:37001 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab1ASW0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:26:41 -0500
Date: Wed, 19 Jan 2011 23:25:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Ungerer <gerg@uclinux.org>,
        Hirokazu Takata <takata@linux-m32r.org>, Jeff Dike <jdike@addtoit.com>,
        Kyle McMartin <kyle@mcmartin.ca>, Michal Simek <monstr@monstr.eu>,
        Mikael Starvik <starvik@axis.com>, Mike Frysinger <vapier@gentoo.org>,
        Paul Mundt <lethal@linux-sh.org>, Richard Henderson <rth@twiddle.net>,
        Tony Luck <tony.luck@intel.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [patch 00/37] genirq: Remove __do_IRQ() and cleanup irq related
 Kconfigs
In-Reply-To: <AANLkTineduG23qitc8ggDKShYJi=2vJgXbYJDjLGZKk3@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101192323190.3211@localhost6.localdomain6>
References: <20110119205258.462759212@linutronix.de> <AANLkTineduG23qitc8ggDKShYJi=2vJgXbYJDjLGZKk3@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1342830710-1295475934=:3211"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1342830710-1295475934=:3211
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 19 Jan 2011, Linus Torvalds wrote:

> On Wed, Jan 19, 2011 at 1:47 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Now that rc1 is out, I got reliable information about the remaining
> > users of __do_IRQ(), which block the removal:
> >
> >  arch/cris, arch/h8300, arch/m32r
> 
> I'm certainly ok with this series. It would be good to finally get rid
> of this legacy interface, and there's no longer any reason to hold it
> up. And getting rid of hundreds of lines of code is good too.

Will wait a day for desperate screams, then collect the incoming acks
and push it into git for your consumption.

Thanks,

	tglx
---1463795968-1342830710-1295475934=:3211--
