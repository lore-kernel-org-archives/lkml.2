Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1GURZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:25:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46762 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1GURZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:25:53 -0400
MIME-Version: 1.0
Date: Thu, 21 Jul 2011 13:25:52 -0400
Message-ID: <CACqU3MUPt3rSm5MMd4_AUygF2uPE_w9a+VdgPk8e9ZNfG0Bu+A@mail.gmail.com>
Subject: Re: linux-next: Tree for July 20 (lockdep warning)
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 20, 2011 at 4:00 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
Not sure which tree is involved, but booting a kernel with qemu
triggers the following warning:

WARNING: at kernel/lockdep.c:2529 trace_hardirqs_on_caller+0x52/0x79()
Hardware name: Bochs
Modules linked in:
Pid: 1, comm: swapper Not tainted 3.0.0-rc7-next-20110720+ #3
Call Trace:
 [<c101bcfd>] warn_slowpath_common+0x65/0x7a
 [<c103da0d>] ? trace_hardirqs_on_caller+0x52/0x79
 [<c11df84c>] ? restore_all+0xf/0xf
 [<c10137a8>] ? vmalloc_sync_all+0x95/0x95
 [<c101bd21>] warn_slowpath_null+0xf/0x13
 [<c103da0d>] trace_hardirqs_on_caller+0x52/0x79
 [<c10be180>] trace_hardirqs_on_thunk+0xc/0x10
 [<c103efb0>] ? cmpxchg_futex_value_locked+0x3d/0x4f
 [<c11df84c>] ? restore_all+0xf/0xf
 [<c10137a8>] ? vmalloc_sync_all+0x95/0x95
 [<c11e0615>] ? iret_exc+0x345/0x984
 [<c143b68f>] ? start_kernel+0x28e/0x28e
 [<c14477d6>] ? futex_init+0x16/0x64
 [<c143b68f>] ? start_kernel+0x28e/0x28e
 [<c1001126>] ? do_one_initcall+0x70/0x11a
 [<c14477c0>] ? lockdep_proc_init+0x67/0x67
 [<c143b68f>] ? start_kernel+0x28e/0x28e
 [<c143b6ff>] ? kernel_init+0x70/0xe9
 [<c11e023a>] ? kernel_thread_helper+0x6/0xd

 - Arnaud
