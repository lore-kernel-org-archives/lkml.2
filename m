Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab2AaRdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 12:33:14 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:60156 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2AaRdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 12:33:13 -0500
Message-ID: <4F2825D1.3030306@numascale.com>
Date: Tue, 31 Jan 2012 18:33:05 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
References: <4F200F4D.5000201@numascale.com> <20120125181441.GD2849@linux.vnet.ibm.com> <4F2070B9.2000104@numascale.com> <20120125213450.GJ2849@linux.vnet.ibm.com> <4F2086DA.4040203@numascale.com> <20120126015843.GN2849@linux.vnet.ibm.com> <4F216B85.7010208@numascale.com> <20120126192653.GC2437@linux.vnet.ibm.com> <4F2285E5.9050705@numascale.com> <20120129060921.GC17696@linux.vnet.ibm.com> <20120130161529.GA5118@linux.vnet.ibm.com>
In-Reply-To: <20120130161529.GA5118@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/2012 17:15, Paul E. McKenney wrote:
[]
>>
>> Hmmm...  I wonder if it waits for a grace period?
>>
>> If it cannot be made to work, I can probably put together some
>> alternative diagnostics, but it will take me a day or three.
>
> Actually, another thing to try is "torture_type=rcu_bh" on the modprobe
> line for rcutorture.  Also, it would be good to get a stack dump of the
> hung process -- it might be hung for some other reason.
>

Paul,

Do not dwell more over this issue at the moment. I have indications that 
the inconsistency we're seeing is related to something else than the RCU 
code itself.

Kind regards,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
