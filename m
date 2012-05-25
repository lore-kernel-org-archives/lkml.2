Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab2EYQ0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:26:42 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65144 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab2EYQ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:26:40 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBb+eHZdsy+bvRw1AY=CS+QAjz3B5OKEkNOOK=EdK8uGyLg@mail.gmail.com>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
	<CA+8MBbJknmrUXG7U_hBaTs4vJ-1Fa-ENq5g3Qzzh6EmsNiSfXg@mail.gmail.com>
	<1337931080.9783.154.camel@laptop>
	<CA+8MBb+eHZdsy+bvRw1AY=CS+QAjz3B5OKEkNOOK=EdK8uGyLg@mail.gmail.com>
Date: Fri, 25 May 2012 09:26:39 -0700
X-Google-Sender-Auth: tHTk12YqUocQk2ljOOzkrsAsxgc
Message-ID: <CA+8MBbJgAMU1rhLxUjCf+T_yNBZ=aif=95gnCpmGr8Coh4bCnw@mail.gmail.com>
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched domain support
From: Tony Luck <tony.luck@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, cmetcalf@tilera.com,
        sivanich@sgi.com, akpm@linux-foundation.org, ralf@linux-mips.org,
        greg.pearson@hp.com, ink@jurassic.park.msu.ru, tglx@linutronix.de,
        rth@twiddle.net, kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, anton@samba.org,
        lethal@linux-sh.org, davem@davemloft.net, benh@kernel.crashing.org,
        dhowells@redhat.com, mattst88@gmail.com, fenghua.yu@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 7:24 AM, Tony Luck <tony.luck@intel.com> wrote:
>> That said, I can only find the 1 alloc_node() in sched_init_numa()

Just to complete the loop - your patch is good ... it isn't necessary to
also change another random kzalloc_node() in an unrelated function
that just happens to be where "n" in vi jumps to :-)

Tested-by: Tony Luck <tony.luck@intel.com>
