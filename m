Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab1EOEPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 00:15:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52158 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1EOEO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 00:14:59 -0400
Message-ID: <4DCF5322.7030305@kernel.org>
Date: Sat, 14 May 2011 21:14:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <4DCAFFD8.2080605@kernel.org> <4DCB157F.20202@kernel.org> <20110512060344.GB3191@elte.hu> <4DCB8BCD.1080607@kernel.org> <4DCB8F7A.90603@kernel.org> <20110512092013.GJ2258@linux.vnet.ibm.com> <4DCC52FB.6030500@kernel.org> <BANLkTin1haL+isnR0UUoHdNm99bnxYPt-g@mail.gmail.com> <20110514142621.GB2258@linux.vnet.ibm.com> <20110514153118.GA24311@linux.vnet.ibm.com> <20110514183453.GA32756@linux.vnet.ibm.com>
In-Reply-To: <20110514183453.GA32756@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DCF532D.003B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2011 11:34 AM, Paul E. McKenney wrote:
>> and do the inspection afterwards.
> 
> And here is a lightly-tested patch, which applies on tip/core/rcu.
> 
> This problem could account for both the long delays seen with e59fb312
> (Decrease memory-barrier usage based on semi-formal proof) and the
> shorter delays seen with a26ac245 (move TREE_RCU from softirq to kthread).

yes. it fixes the problem.

for 1024g system when hotadd mem enabled in kernel config

[   31.814803] cpu_dev_init done
[   35.437163] memory_dev_init done

even it is with gcc from opensuse 11.3

Thanks

Yinghai
