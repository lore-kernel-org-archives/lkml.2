Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab1AJXgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:36:12 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42701 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1AJXgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:36:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rwkOnm0itOg5f84UBjithp2HCp2S5Ms9NWagSvZGZ5IJ34g7nVdYUjsiCp7Jdu9L10
         hwHpyveGcfonGWAQObBQv3ax+6Of7KBWi8c8ZM+QvzeSyZOlDtqIdVZo3kiKcuIO3aVs
         v0XXS8ojLI4BB9txh3feyphVyUG8LLIb/fQTM=
MIME-Version: 1.0
In-Reply-To: <AANLkTin7h=R0cfzpeuvpTAGRFCsFocJezpW7Riz5Za4z@mail.gmail.com>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
	<4D2ADD43.2020702@gmail.com>
	<AANLkTin7h=R0cfzpeuvpTAGRFCsFocJezpW7Riz5Za4z@mail.gmail.com>
Date: Mon, 10 Jan 2011 15:36:09 -0800
Message-ID: <AANLkTimeUN9m-roDmsfaMaiD4wZw1wETYsf+dONjpmyj@mail.gmail.com>
Subject: Re: WARNING: at kernel/workqueue.c [was: mmotm 2011-01-06-15-41 uploaded]
From: Tony Luck <tony.luck@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here it is, too.
> mmotm-01-06

Also in today's linux-next (tag: next-20110110) on ia64:


------------[ cut here ]------------
WARNING: at kernel/workqueue.c:1202 worker_enter_idle+0x3f0/0x4a0()
Hardware name: server rx2620
Modules linked in:

Call Trace:
 [<a000000100014cb0>] show_stack+0x50/0xa0
                                sp=e0000040600d7c30 bsp=e0000040600d0dd0
 [<a000000100bcaa20>] dump_stack+0x30/0x50
                                sp=e0000040600d7e00 bsp=e0000040600d0db8
 [<a000000100082260>] warn_slowpath_common+0xc0/0x100
                                sp=e0000040600d7e00 bsp=e0000040600d0d78
 [<a0000001000822e0>] warn_slowpath_null+0x40/0x60
                                sp=e0000040600d7e00 bsp=e0000040600d0d50
 [<a0000001000b0830>] worker_enter_idle+0x3f0/0x4a0
                                sp=e0000040600d7e00 bsp=e0000040600d0d28
 [<a0000001000b2c80>] worker_thread+0x8c0/0x980
                                sp=e0000040600d7e00 bsp=e0000040600d0c28
 [<a0000001000c08c0>] kthread+0x120/0x160
                                sp=e0000040600d7e00 bsp=e0000040600d0be8
 [<a000000100012ef0>] kernel_thread_helper+0x30/0x60
                                sp=e0000040600d7e30 bsp=e0000040600d0bc0
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e0000040600d7e30 bsp=e0000040600d0bc0
---[ end trace 7e2fb881ec0622f8 ]---
