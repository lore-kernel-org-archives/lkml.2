Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1CXBbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 21:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab1CXBbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 21:31:10 -0400
Message-ID: <4D8A9ED7.5040709@redhat.com>
Date: Thu, 24 Mar 2011 09:31:03 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix linux/smp.h to include linux/init.h
References: <20110323113502.30322.26599.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110323113502.30322.26599.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年03月23日 19:35, David Howells 写道:
> linux/smp.h now needs to include linux/init.h lest it give the following error:
>
>    CC      arch/mn10300/kernel/asm-offsets.s
> In file included from /data/mn10300/linux-2.6-mn10300/arch/mn10300/include/asm/irqflags.h:17,
>                   from include/linux/irqflags.h:15,
>                   from include/linux/spinlock.h:53,
>                   from include/linux/seqlock.h:29,
>                   from include/linux/time.h:8,
>                   from include/linux/timex.h:56,
>                   from include/linux/sched.h:57,
>                   from arch/mn10300/kernel/asm-offsets.c:7:
> include/linux/smp.h:117: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'setup_nr_cpu_ids'
> include/linux/smp.h:118: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'smp_init'
>
> Signed-off-by: David Howells<dhowells@redhat.com>

Hi, David,

Heiko sent a same patch before you did. :)

Thanks.
