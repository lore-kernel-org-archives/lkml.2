Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab1FVPBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:01:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:49143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab1FVPBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:01:18 -0400
Subject: Re: [PATCH 0/4] printk: Remove lockdep_off() and wakeups -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, efault@gmx.de
In-Reply-To: <20110622115030.GA13675@elte.hu>
References: <20110621151725.705140475@chello.nl>
	 <1308734409.1022.14.camel@twins>  <20110622115030.GA13675@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Jun 2011 15:44:31 +0200
Message-ID: <1308750271.1022.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 13:50 +0200, Ingo Molnar wrote:
> this series still hangs in a similar way:
> 
> [   11.311422] calling  tcp_congestion_default+0x0/0x12 @ 1
> [   11.316754] initcall tcp_congestion_default+0x0/0x12 returned 0 after 4 usecs
> [   11.323900] calling  initialize_hashrnd+0x0/0x19 @ 1
> [   11.328892] initcall initialize_hashrnd+0x0/0x19 returned 0 after 8 usecs
> [ hard hang ]
> 
> config and bootlog attached.

I'm getting all the way to userspace but then loose because the Fedora
init scripts explode, leaving me with a machine that's useless but does
return pings.

And I'm too using AMD hardware for this (although not the same).


