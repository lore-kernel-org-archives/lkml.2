Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0LPUnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:43:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53689 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256Ab0LPUnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:43:06 -0500
Message-ID: <4D0A799F.4060408@zytor.com>
Date: Thu, 16 Dec 2010 12:42:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home> <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com>
In-Reply-To: <4D0A3AF2.50508@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 08:14 AM, Tejun Heo wrote:
> Hey, again.
> 
> On 12/15/2010 05:39 PM, Tejun Heo wrote:
>> I'd prefer percpu things going through percpu tree, if for nothing
>> else for git history's sake, but I don't think it really matters.  The
>> series is spread all over the place anyway.  As long as each
>> maintainer is properly alerted about the changes, it should be okay.
>> Please let me know whether you agree with the changes currently queued
>> in percpu#for-next.  I'll update the tree with your Acked-by's and
>> freeze it.
> 
> Are you okay with the patches currently in percpu#for-next?  If so,
> I'll regenerate patches with your acked-by and pop the two previously
> mentioned commits and proceed with the rest of the series.
> 

Just finished reviewing the patches in percpu#for-next.

Acked-by: H. Peter Anvin <hpa@zytor.com>

Look good.  Let me know when you have a baseline I can pull into a tip
branch so we can build the rest of the patches on top.

	-hpa
