Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1HER3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:29:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32995 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab1HER3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:29:12 -0400
Subject: Re: Unlucky 3.0-rt7
From: Peter Zijlstra <peterz@infradead.org>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: linux-rt-users@vger.kernel.org, Tracey Hytry <shakti@bayarea.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 05 Aug 2011 19:29:02 +0200
In-Reply-To: <4E3C224D.4050609@ccrma.stanford.edu>
References: <20110805054017.472bef0d.shakti@bayarea.net>
	 <4E3C1475.7040908@ccrma.stanford.edu> <4E3C224D.4050609@ccrma.stanford.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312565342.28695.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 10:03 -0700, Fernando Lopez-Lezcano wrote:
> [    0.000000]  [<c04fc9e1>] kmem_cache_free+0x6c/0xdc
> [    0.000000]  [<c04fcaa0>] slab_destroy+0x4f/0x53
> [    0.000000]  [<c04fcb38>] free_block+0x94/0xc1
> [    0.000000]  [<c04fdcea>] do_tune_cpucache+0x10b/0x2bb
> [    0.000000]  [<c04fe075>] enable_cpucache+0x7b/0xa7
> [    0.000000]  [<c0bdd355>] kmem_cache_init_late+0x2f/0x6a
> [    0.000000]  [<c0bbd68c>] start_kernel+0x251/0x368
> [    0.000000]  [<c0bbd1c4>] ? loglevel+0x18/0x18
> [    0.000000]  [<c0bbd0ba>] i386_start_kernel+0xa9/0xaf 

Ah, I actually have a patch for that but didn't include it in -rt, only
pushed it upstream.. silly me. Let me include all those lockdep fixes.
