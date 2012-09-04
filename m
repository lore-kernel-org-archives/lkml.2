Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab2IDTUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:20:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37641 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab2IDTUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:20:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120904161737.358d51ad@obelix.rh>
References: <20120904143215.5bbbb2a4@obelix.rh>
	<CAE9FiQUEHbDySWHWFj6kW=HGLR0vkbaJWRq+7kMMHGhBm8e08A@mail.gmail.com>
	<20120904161737.358d51ad@obelix.rh>
Date: Tue, 4 Sep 2012 12:20:14 -0700
X-Google-Sender-Auth: b2zJ6kTi4zygWVn08MTzHnCWLq8
Message-ID: <CAE9FiQX7OMdFU6FuTQdz+NdbNt5Hy9zjzSY7y-90G4CbhayfaA@mail.gmail.com>
Subject: Re: kexec/kdump kernel fails to start
From: Yinghai Lu <yinghai@kernel.org>
To: Flavio Leitner <fbl@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
        ianfang.cn@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 12:17 PM, Flavio Leitner <fbl@redhat.com> wrote:
> On Tue, 4 Sep 2012 12:02:00 -0700
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
> [    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
> [    0.000000]  0000000000 - 00bf800000 page 2M
> [    0.000000] kernel direct mapping tables up to bf800000 @ 1fa00000-20000000
> [    0.000000] init_memory_mapping: 0000000100000000-0000000440000000
> [    0.000000]  0100000000 - 0440000000 page 2M
> [    0.000000] kernel direct mapping tables up to 440000000 @ bdaab000-bf4bd000
> [    0.000000] RAMDISK: 352c8000 - 3695c000
>
BTW, can you please try our new init_memory_mapping clean up at

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-mm

hope it could make your kdump working.

Thanks

Yinghai
