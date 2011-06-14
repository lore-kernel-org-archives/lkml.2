Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1FNPMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:12:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38607 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab1FNPML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:12:11 -0400
Message-ID: <4DF778AB.3@zytor.com>
Date: Tue, 14 Jun 2011 08:05:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, tj@kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
References: <20110601172543.437240675@linux.com> <20110601172614.173427964@linux.com> <4DF09827.7070809@cs.helsinki.fi> <alpine.DEB.2.00.1106101016420.30968@router.home> <BANLkTikHOsvR-KXZ-VQvpAaMgrNOR0sB3g@mail.gmail.com> <alpine.DEB.2.00.1106111202110.32170@router.home> <4DF6F659.3000109@cs.helsinki.fi> <20110614080436.GB29900@elte.hu> <alpine.DEB.2.00.1106140903480.32130@router.home>
In-Reply-To: <alpine.DEB.2.00.1106140903480.32130@router.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 07:04 AM, Christoph Lameter wrote:
> On Tue, 14 Jun 2011, Ingo Molnar wrote:
> 
>>
>> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>
>>> On 6/11/11 8:02 PM, Christoph Lameter wrote:
>>>> On Sat, 11 Jun 2011, Pekka Enberg wrote:
>>>>
>>>>> Oh, I don't know - but I definitely need more ACKs to even consider
>>>>> pushing this through slab.git.
>>>>
>>>> Any additional ackers out there?;-)
>>>
>>> Ingo, ping? Could we have this in -tip so I can pull from there?
>>> This is blocking me from queuing SLUB performance improvements to
>>> linux-next.
>>
>> hpa, what's your take on this patch?
> 
> He acked it.
> 

Yep, looks fine now.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

