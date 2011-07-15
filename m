Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862Ab1GOGDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:03:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59586 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460Ab1GOGDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:03:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ8eaTyqOBq2mbfvuTun=bVvhFSrMqJ5uVyd+cozF5PtVeSVaw@mail.gmail.com>
References: <CAJ8eaTzLmSTSMOY-0Xg0tE-DEbZ6RNA+uh70Dn3K5CbrjQsEiA@mail.gmail.com>
	<CABi1daHh7cgyhJ4c3zo+jSUY4uzbFtihtgw0Q2Mcrndno_gcTA@mail.gmail.com>
	<CAJ8eaTyqOBq2mbfvuTun=bVvhFSrMqJ5uVyd+cozF5PtVeSVaw@mail.gmail.com>
Date: Thu, 14 Jul 2011 23:03:17 -0700
Message-ID: <CABi1daFp=mKw0kq=Vm_T9RKeHfnXsA-kssdRm56AhkaJ4FjCxA@mail.gmail.com>
Subject: Re: ARM cortex A9 feature
From: Dave Hylands <dhylands@gmail.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi naveen,

On Thu, Jul 14, 2011 at 10:15 PM, naveen yadav <yad.naveen@gmail.com> wrote:
> Hi dave,
>
> Thanks for answering, but I think question 2, answer  is still not clear to me .
>
> my question is why exclusive L2.
>
> 8.1.4 Exclusive L2 cache
> The Cortex-A9 processor can be connected to an L2 cache that supports
> an exclusive cache
> mode. This mode must be activated both in the Cortex-A9 processor and
> in the L2 cache
> controller.
> In this mode, the data cache of the Cortex-A9 processor and the L2
> cache are exclusive. At any
> time, a given address is cached in either L1 data caches or in the L2
> cache, but not in both. This
> has the effect of greatly increasing the usable space and efficiency
> of an L2 cache connected to
> the Cortex-A9 processor. When exclusive cache configuration is selected:
> • Data cache line replacement policy is modified so that the victim
> line always gets evicted
> to L2 memory, even if it is clean.
> • If a line is dirty in the L2 cache controller, a read request to this address
>
>
> what is usecase for this . This is my question .

Since I've never used one, I'm not sure. Maybe somebody else knows.

-- 
Dave Hylands
Shuswap, BC, Canada
http://www.davehylands.com
