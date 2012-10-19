Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab2JSOaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:30:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:49928 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2JSOaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:30:04 -0400
Message-ID: <1350656961.2768.20.camel@twins>
Subject: Re: [PATCH RT] slab: Fix up stable merge of slab init_lock_keys()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Date: Fri, 19 Oct 2012 16:29:21 +0200
In-Reply-To: <1350567601.19292.69.camel@pippen.local.home>
References: <1350567601.19292.69.camel@pippen.local.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 09:40 -0400, Steven Rostedt wrote:
> Peter,
> 
> There was a little conflict with my merge of 3.4.14 due to the backport
> of this patch:
> 
> commit 947ca1856a7e60aa6d20536785e6a42dff25aa6e
> Author: Michael Wang <wangyun@linux.vnet.ibm.com>
> Date:   Wed Sep 5 10:33:18 2012 +0800
> 
>     slab: fix the DEADLOCK issue on l3 alien lock
> 
> Could you just confirm that my fix is correct.

We forever keep getting that issue wrong it seems.. so I'd not put too
much trust into whatever my sleep addled brain thinks today :/

Looks about right, but who knows ;-)
