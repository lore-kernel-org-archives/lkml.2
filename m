Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab1BNTgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:36:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20307 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1BNTgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:36:13 -0500
Message-ID: <4D5983EA.4020103@kernel.org>
Date: Mon, 14 Feb 2011 11:35:06 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk registration
References: <1297530663-26234-16-git-send-email-tj@kernel.org> <4D5729A7.7070706@kernel.org> <20110214113221.GG18742@htj.dyndns.org> <AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com> <20110214161249.GV18742@htj.dyndns.org> <AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com> <20110214162247.GX18742@htj.dyndns.org> <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com> <20110214182718.GB18742@htj.dyndns.org> <4D597D56.5060408@kernel.org> <20110214193050.GC18742@htj.dyndns.org>
In-Reply-To: <20110214193050.GC18742@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D59841A.0181,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 11:30 AM, Tejun Heo wrote:
> On Mon, Feb 14, 2011 at 11:07:02AM -0800, Yinghai Lu wrote:
>> Never mind. will send out patch after your patches get merged into tip.
> 
> Alright, fair enough.
> 
>> BTW, you may need to rebase your on top of tip/master.
> 
> Yeah, I saw a new patch going into the numa branch, but shouldn't this
> and the next series based on x86/numa?  That was how it was done with
> the previous series.

there is patch about init_memory_mapping_high() in tip/x86/bootmem.
it will put pgtable on local nodes.

Yinghai

