Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0LOQg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:36:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53685 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab0LOQg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:36:56 -0500
Message-ID: <4D08EE57.8010602@zytor.com>
Date: Wed, 15 Dec 2010 08:35:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home> <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org>
In-Reply-To: <4D08ECEF.3040909@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 08:29 AM, Tejun Heo wrote:
> Hello,
> 
> On 12/15/2010 02:06 AM, H. Peter Anvin wrote:
>> It's probably easiest if you just add them with my Acked-by: then.
>> Alternatively, I could pick them up so they go into -tip and the tip
>> test machinery.
> 
> All patches accepted into percpu till now are in the following branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-next
> 
> The tree is based on v2.6.37-rc5 and v2.6.37-rc5..for-next would give
> 21 patches.  I think most of these don't fit x86 tree but there are
> several which would fit there much better.  d80aadf9 (x86: Replace
> uses of current_cpu_data with this_cpu ops) and e5195e91 (x86: Use
> this_cpu_inc_return for nmi counter).
> 
> As it would be beneficial to push these through -tip testing anyway,
> how about the following?
> 
> * If you review and ack the x86 related bits in the series, I'll
>   regenerated and add the ACKs.
> 
> * It would be better if the two commits mentioned above get routed
>   through x86 tree rather than percpu tree, so I'll drop the above two
>   from percpu tree and you can pull percpu into x86 and then apply
>   those in x86 tree.
> 

I think we can do that... let me look through the tree first officially
committing.  Alternatively, I can pull the patches from your tree and
individually review them and add them to a tip branch, if you prefer.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

