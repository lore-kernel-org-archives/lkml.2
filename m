Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935064Ab0KQRSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:18:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:48559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935040Ab0KQRS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:18:29 -0500
Subject: Re: [PATCH] kernel/time: Make /proc/timer_list mode 0400
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Marcus Meissner <meissner@suse.de>
Cc: tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101117170822.GW20727@suse.de>
References: <20101117170822.GW20727@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 18:18:32 +0100
Message-ID: <1290014312.2109.1065.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 18:08 +0100, Marcus Meissner wrote:
> Hi,
> 
> /proc/timer_list contains kernel addresses, like e.g.:
>  #0: <c000000001404158>, tick_sched_timer, S:01, .tick_nohz_restart_sched_tick, swapper/0
>  ...
> 
> Avoid leaking them to user space to make writing kernel exploits a bit harder.
> 
> (I currently cannot think of a userland tool that uses this, this is
> likely pretty much root-only.)

iirc powertop parses this..
