Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2IENrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:47:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab2IENrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:47:15 -0400
Date: Wed, 5 Sep 2012 10:46:51 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
        ianfang.cn@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kexec/kdump kernel fails to start
Message-ID: <20120905104651.64b40663@obelix.rh>
In-Reply-To: <CAE9FiQWhkPG1AuwW-_REYiBxBtMo+5gpfpgx3Yy2wXZY2JX2kg@mail.gmail.com>
References: <20120904143215.5bbbb2a4@obelix.rh>
	<CAE9FiQUEHbDySWHWFj6kW=HGLR0vkbaJWRq+7kMMHGhBm8e08A@mail.gmail.com>
	<20120904161737.358d51ad@obelix.rh>
	<CAE9FiQX7OMdFU6FuTQdz+NdbNt5Hy9zjzSY7y-90G4CbhayfaA@mail.gmail.com>
	<20120904172639.0c2bfd6d@obelix.rh>
	<CAE9FiQWnz-pC3ODOfKo6jumGztd1MdypXB5PG-eDrAfTb1s_xQ@mail.gmail.com>
	<20120904183708.5f10fbde@obelix.rh>
	<CAE9FiQXCzQ+GCCqx4+=ZSijn+_+ekfGrUABiWNuX2H8BL+j9tg@mail.gmail.com>
	<20120904210114.1a30338a@obelix.rh>
	<CAE9FiQWhkPG1AuwW-_REYiBxBtMo+5gpfpgx3Yy2wXZY2JX2kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012 18:15:25 -0700
Yinghai Lu <yinghai@kernel.org> wrote:
> assume when we have good_end setting for 64 bit, page table for [4g,
> TOMH) will be just under 512M, and later when first
> first 2M lines changes, will push that page table range a little low,
> and will make kdump not happy.
> 
> BTW the first 2M change commit is useless should be reverted. because
> even it is in 2M page mapping at first, later
> kernel will change to 4k page.
> 
> and with other change in this patchset, init_memory_mapping(0,
> ISA_END_ADDR) will always make sure first 2M use 4K page.

Hm, it's not clear to me. Are you going to push the patch reverting
that commit and then your patchset?

thank you!
fbl
