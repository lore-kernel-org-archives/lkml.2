Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161066Ab2KNKGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:06:06 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48837 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161016Ab2KNKGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:06:03 -0500
Date: Wed, 14 Nov 2012 02:06:00 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Jones <davej@redhat.com>
cc: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: fix shmem_getpage_gfp VM_BUG_ON
In-Reply-To: <20121114061437.GA23458@redhat.com>
Message-ID: <alpine.LNX.2.00.1211140204430.19559@eggly.anvils>
References: <alpine.LNX.2.00.1211011546090.19377@eggly.anvils> <20121101232030.GA25519@redhat.com> <alpine.LNX.2.00.1211011627120.19567@eggly.anvils> <20121102014336.GA1727@redhat.com> <alpine.LNX.2.00.1211021606580.11106@eggly.anvils>
 <alpine.LNX.2.00.1211051729590.963@eggly.anvils> <20121106135402.GA3543@redhat.com> <alpine.LNX.2.00.1211061521230.6954@eggly.anvils> <50A30ADD.9000209@gmail.com> <alpine.LNX.2.00.1211131935410.30540@eggly.anvils> <20121114061437.GA23458@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Dave Jones wrote:
> On Tue, Nov 13, 2012 at 07:50:25PM -0800, Hugh Dickins wrote:
>  
>  > Originally I was waiting to hear further from Dave; but his test
>  > machine was giving trouble, and it occurred to me that, never mind
>  > whether he says he has hit it again, or he has not hit it again,
>  > the answer is the same: don't send that VM_BUG_ON upstream.
>  
> Sorry, I'm supposedly on vacation. 

Sorry for breaking in upon that, and thank you for responding even so.

> That said, a replacement test box has been running tests since last Friday
> without hitting that case.  Maybe it was the last death throes of
> that other machine before it gave up the ghost completely.
> 
> Does sound like an awful coincidence though.

I'm still clinging to your 0.1% possibility that it was not the
intended kernel running.

Anyway, I'm not going to worry about it further, until we see another
hit - please do keep the VM_BUG_ON in your test kernel (i.e. resist
that temptation to race in from your vacation to apply today's patch!),
even though the right thing for 3.7 was to remove it.

Thanks,
Hugh
