Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2EYOY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:24:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34827 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2EYOY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:24:57 -0400
MIME-Version: 1.0
In-Reply-To: <1337931080.9783.154.camel@laptop>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
	<CA+8MBbJknmrUXG7U_hBaTs4vJ-1Fa-ENq5g3Qzzh6EmsNiSfXg@mail.gmail.com>
	<1337931080.9783.154.camel@laptop>
Date: Fri, 25 May 2012 07:24:55 -0700
X-Google-Sender-Auth: 6R5XN7bxhPCOeozSDoEL6Ysr6hs
Message-ID: <CA+8MBb+eHZdsy+bvRw1AY=CS+QAjz3B5OKEkNOOK=EdK8uGyLg@mail.gmail.com>
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

On Fri, May 25, 2012 at 12:31 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Right,.. and its not too important either, so lets just use regular
> allocations.

Thanks.

> That said, I can only find the 1 alloc_node() in sched_init_numa()

Doh - I must have searched for the next, and not noticed that
I had skipped into a different function,

-Tony
