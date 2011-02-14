Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1BNTIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:08:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60447 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1BNTIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:08:30 -0500
Message-ID: <4D597D56.5060408@kernel.org>
Date: Mon, 14 Feb 2011 11:07:02 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk registration
References: <1297530663-26234-1-git-send-email-tj@kernel.org> <1297530663-26234-16-git-send-email-tj@kernel.org> <4D5729A7.7070706@kernel.org> <20110214113221.GG18742@htj.dyndns.org> <AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com> <20110214161249.GV18742@htj.dyndns.org> <AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com> <20110214162247.GX18742@htj.dyndns.org> <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com> <20110214182718.GB18742@htj.dyndns.org>
In-Reply-To: <20110214182718.GB18742@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D597D7C.000D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 10:27 AM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Feb 14, 2011 at 10:14:15AM -0800, Yinghai Lu wrote:
>> I just want seperate setup_bootmem  ( and maybe init_memory_mapping_high...)
>> out  that __register__ function.
>>
>> that __register__ function do some sth like memblock_register to
>> early_node_map[] looks reasonable.
> 
> Can you please provide some rationales _why_ you think setup_bootmem()
> should be moved elsewhere?  Because it is not apparent to me and I
> cannot read your mind.  I'm not against it given good enough reasons.
> After all, _technically_ it doesn't make one iota of difference, but I
> don't want to change it just because you don't like it and I don't
> think you want that either, so _please_ give me some explanations
> about what you want and _why_.  It's not like we're involved in a
> romantic relationship and even when I'm in one I suck at that implied
> communication thing.

Never mind. will send out patch after your patches get merged into tip.

BTW, you may need to rebase your on top of tip/master.

Thanks

Yinghai
