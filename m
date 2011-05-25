Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1EYWt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 18:49:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18075 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1EYWt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 18:49:58 -0400
Message-ID: <4DDD8775.1000501@kernel.org>
Date: Wed, 25 May 2011 15:49:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
References: <4DDAD934.9010603@kernel.org> <4DDAE5FA.2030303@kernel.org> <4DDAE6A5.6060701@kernel.org> <20110524011824.GL7428@linux.vnet.ibm.com> <4DDB093F.2060601@kernel.org> <20110524013523.GO7428@linux.vnet.ibm.com> <4DDC21E1.1070502@kernel.org> <4DDC48E3.1060108@kernel.org> <20110525045253.GB2262@linux.vnet.ibm.com> <4DDD7F96.3090408@kernel.org> <20110525223437.GO2341@linux.vnet.ibm.com>
In-Reply-To: <20110525223437.GO2341@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DDD877A.00DD,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 03:34 PM, Paul E. McKenney wrote:
> On Wed, May 25, 2011 at 03:15:50PM -0700, Yinghai Lu wrote:
>>> There is a new branch yinghai.2011.05.24a on:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
>>>
>>> Or will be as soon as kernel.org updates its mirrors.
>>>
>>> I am not sure I could call this "clean", but it does revert that commit
>>> and 11 of the subsequent commits that depend on it.  It does build,
>>> and I will test it once my currently running tests complete.
>>
>> yes, with those revert, there is no delay in 10 times booting.
> 
> Unfortunately, there are rcutorture test failures with the revert...

confused.

what is the next?

Yinghai

