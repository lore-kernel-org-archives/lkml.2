Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0LOQdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:33:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36993 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab0LOQdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:33:38 -0500
Message-ID: <4D08EDA8.90702@zytor.com>
Date: Wed, 15 Dec 2010 08:32:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 2/4] x86: this_cpu_cmpxchg_double()
 support
References: <20101214174847.887713690@linux.com> <20101214174900.659284593@linux.com> <4D080FDC.7030005@zytor.com> <4D081225.8000007@zytor.com> <alpine.DEB.2.00.1012151011550.12186@router.home>
In-Reply-To: <alpine.DEB.2.00.1012151011550.12186@router.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 08:12 AM, Christoph Lameter wrote:
> On Tue, 14 Dec 2010, H. Peter Anvin wrote:
> 
>>> NAK on this.  This is acceptable for cmpxchg8b only because we don't
>>> support SMP on 486s anymore.  x86-64 is another matter...
>>>
>>
>> Hm, this is meant to be a CPU local operation, isn't it... it isn't very
>> clear from the comments or naming *in this file*.
> 
> Ok. But the code is correct as far as I can tell. Its not a global cmpxchg
> but local. Interrupt disable is ok.
> 
>> Could you make it a little clearer in the local code, please?
> 
> ok.
> 

Yes, that's what I meant... the code is correct, it's just not obvious
from someone who looks at the code that it is correct, because the
intended function of the code isn't obvious from that file by itself (in
fact, it looks almost exactly like the 486 cmpxchg ersatz code.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

