Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2DQW5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 18:57:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:58735 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2DQW5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 18:57:41 -0400
Date: Wed, 18 Apr 2012 00:56:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sasikantha babu <sasikanth.v19@gmail.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Kevin Tian <kevin.tian@intel.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 1/3] Added new Proc entry to display per-cpu interrupts
In-Reply-To: <1334677205-2623-1-git-send-email-sasikanth.v19@gmail.com>
Message-ID: <alpine.LFD.2.02.1204180034380.2542@ionos>
References: <1334677205-2623-1-git-send-email-sasikanth.v19@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012, Sasikantha babu wrote:

Sigh. I told you before, that a subject line of a patch which starts
with: "Added ..." is useless.

Please use the proper prefix for the subsystem and a reasonable
subject.

> As the number of cores increases the output of the /proc/interrupts losing the readability.
> 

And please use a proper mail client which does line wraps around 78 chars.

> As the number of cores increases the output of the /proc/interrupts
> losing the readability.

That's how it should look like.

> I think instead of showing complete information of all cores in a
> single proc file spliting the information based on per-CPU will be
> more useful (especially for people who wants to track per-cpu
> information in real-time systems).

That has nothing to do with real time systems. /proc/interrupts is
unreadable on any machine with a large number of cores.

What the heck is wrong with

cat /proc/interrupts | grep $YOUR_IRQ_OF_INTEREST | awk '{ print $CPU_ROW }'


Thanks,

	tglx
