Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1IGQWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:22:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57413 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab1IGQV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:21:56 -0400
MIME-Version: 1.0
In-Reply-To: <4E66414E.8060100@blueyonder.co.uk>
References: <4E66414E.8060100@blueyonder.co.uk>
Date: Wed, 7 Sep 2011 18:58:11 +0800
Message-ID: <CAM_iQpX4tWS7VbPvrFTqEGv0GzfTm+sygPhqDz+yHVUGSEGhXA@mail.gmail.com>
Subject: Re: 3.x memleaks
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: sboyce@blueyonder.co.uk
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 11:50 PM, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
> Since 3.0 I have been seeing memleaks, right up to 3.1.0-rc5. This is
> typical.
> AMD x86_64, X2, X4's and openSUSE 12.1 Milestones.
> unreferenced object 0xffff88022f007000 (size 512):
>  comm "swapper", pid 1, jiffies 4294667649 (age 17727.056s)
>  hex dump (first 32 bytes):
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  backtrace:
>    [<ffffffff81490ba6>] kmemleak_alloc+0x56/0xb0
>    [<ffffffff8113ca4c>] kmem_cache_alloc_node_trace+0x9c/0x1d0
>    [<ffffffff81041ea7>] __sdt_alloc+0xa7/0x1e0
>    [<ffffffff81042014>] __visit_domain_allocation_hell+0x34/0xc0
>    [<ffffffff8104d489>] build_sched_domains+0x29/0x2e0
>    [<ffffffff81c4c5de>] sched_init_smp+0x7d/0x168
>    [<ffffffff81c36cca>] kernel_init+0xb8/0x159
>    [<ffffffff814bfbb4>] kernel_thread_helper+0x4/0x10
>    [<ffffffffffffffff>] 0xffffffffffffffff

Hello,

This should be fixed by: https://lkml.org/lkml/2011/8/29/218

Thanks!
