Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab0LNRXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:23:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56730 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab0LNRXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:23:15 -0500
Message-ID: <4D07A7CB.7010205@zytor.com>
Date: Tue, 14 Dec 2010 09:22:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home>
In-Reply-To: <alpine.DEB.2.00.1012141109470.17229@router.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 09:19 AM, Christoph Lameter wrote:
>>
>> Is it genuinely faster to do the pre-load mov, or can we drop that too?
>>  My guess would be that yes it is, but if it happens not to be it would
>> be nice to reduce the code size.
> 
> Dropping the load increases the cycle count from 11 to 16.
> 

Great, that answers that!  I'll pick up the patch hopefully today (I'm
finally ramping back up on arch/x86 again after having been diverted to
an internal project for a while...)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

