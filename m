Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab0ENQkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:40:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26781 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab0ENQk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:40:29 -0400
Message-ID: <4BED7DFE.2090108@oracle.com>
Date: Fri, 14 May 2010 09:44:46 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: benh@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 11/35] lmb: Add find_memory_core_early()
References: <1273804238.21352.389.camel@pasglop>	<4BECF00D.6080800@oracle.com>	<1273825187.21352.590.camel@pasglop> <20100514.013012.13730149.davem@davemloft.net>
In-Reply-To: <20100514.013012.13730149.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BED7CEA.00A1:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 01:30 AM, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Fri, 14 May 2010 18:19:47 +1000
>
>   
>> OK, I'll have to let Davem deal with the fine point of the sparc bits,
>> but I think basically sparc has CONFIG_ARCH_POPULATES_NODE_MAP set, but
>> the way it's NUMA affinity works, the early_node_map[] is crap, you
>> cannot rely on the ranges in there.
>>     
>   

> Right, we can't use early_node_map[] on sparc, because the NUMA
> mappings are far too granular to use that kind of representation.
>   
good to know.

early_node_map[] doesn't have enough slot?

YH
