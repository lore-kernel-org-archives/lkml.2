Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab0GPSsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:48:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51950 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790Ab0GPSsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:48:16 -0400
Message-ID: <4C40A83B.2090108@kernel.org>
Date: Fri, 16 Jul 2010 11:43:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@kernel.org>
Subject: Re: [PATCH] kmemleak: Add support for NO_BOOTMEM configurations
References: <20100715145834.20885.20341.stgit@e102109-lin.cambridge.arm.com>	 <4C3F4286.3070503@kernel.org> <1279269963.24890.8.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1279269963.24890.8.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C40A941.00BE,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 01:46 AM, Catalin Marinas wrote:
> On Thu, 2010-07-15 at 18:16 +0100, Yinghai Lu wrote:
> On 07/15/2010 07:58 AM, Catalin Marinas wrote: 
>>> With commits 08677214 and 59be5a8e, alloc_bootmem()/free_bootmem() and
>>> friends use the early_res functions for memory management when
>>> NO_BOOTMEM is enabled. This patch adds the kmemleak calls in the
>>> corresponding code paths for bootmem allocations.
>>>
>>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>> Cc: H. Peter Anvin <hpa@zytor.com>
>>
>> should be for 2.6.34 and 2.6.35.
> 
> I only noticed it recently since we don't have NO_BOOTMEM on ARM.
> Anyway, I'll cc stable@kernel.org when pushing the patch to Linus.
> 
> Should I consider your reply as an acked-by?
> 

Yes.

Thanks

Yinghai
