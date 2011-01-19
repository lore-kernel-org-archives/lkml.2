Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1ASWVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:21:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798Ab1ASWVN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:21:13 -0500
MIME-Version: 1.0
In-Reply-To: <20110119205258.462759212@linutronix.de>
References: <20110119205258.462759212@linutronix.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Jan 2011 14:13:07 -0800
Message-ID: <AANLkTineduG23qitc8ggDKShYJi=2vJgXbYJDjLGZKk3@mail.gmail.com>
Subject: Re: [patch 00/37] genirq: Remove __do_IRQ() and cleanup irq related Kconfigs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 1:47 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Now that rc1 is out, I got reliable information about the remaining
> users of __do_IRQ(), which block the removal:
>
>  arch/cris, arch/h8300, arch/m32r

I'm certainly ok with this series. It would be good to finally get rid
of this legacy interface, and there's no longer any reason to hold it
up. And getting rid of hundreds of lines of code is good too.

                Linus
