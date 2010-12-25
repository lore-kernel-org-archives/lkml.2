Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab0LYGMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 01:12:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38577 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab0LYGMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 01:12:05 -0500
Message-ID: <4D158AFA.4000607@zytor.com>
Date: Fri, 24 Dec 2010 22:11:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for this_cpu_cmpxchg_double
References: <20101214174847.887713690@linux.com> <20101214174900.058235985@linux.com> <4D0CC982.3030905@kernel.org> <alpine.DEB.2.00.1012211634560.3769@router.home> <4D11373D.9010205@zytor.com> <20101222091358.GC27861@htj.dyndns.org> <alpine.DEB.2.00.1012231812280.22549@router.home> <4D13E7D5.7020503@zytor.com> <alpine.DEB.2.00.1012242251090.23107@router.home>
In-Reply-To: <alpine.DEB.2.00.1012242251090.23107@router.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2010 08:53 PM, Christoph Lameter wrote:
> On Thu, 23 Dec 2010, H. Peter Anvin wrote:
> 
>> There are two return registers; two machine registers can be returned in
>> registers.  [u]int128 is poorly implemented in a lot of gcc versions,
>> since it really hasn't been exercised.  However, two-word structures
>> should work.  I do not believe a two-word *array* works, though.
> 
> Oh gosh. So we would be using a tight corner case for gcc that may only
> work with certain versions of gcc? Note that the current version does only
> return a boolean. There is no need for returning double words. I'd be
> happy if we could *pass* double words.
> 


A structure is not a corner case; a uint128 would be.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

