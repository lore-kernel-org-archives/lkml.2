Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2I1GJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:09:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:33087 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab2I1GJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:09:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,499,1344236400"; 
   d="scan'208";a="198240799"
Message-ID: <50653EFB.2080600@intel.com>
Date: Fri, 28 Sep 2012 14:08:59 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Distinguish TLB shootdown interrupts from other
 functions call interrupts
References: <50611D82.4010702@intel.com> <20120926021128.22212.20440.stgit@hpxw> <5063F9FD.8050002@intel.com> <50653A7A.1020806@zytor.com>
In-Reply-To: <50653A7A.1020806@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 01:49 PM, H. Peter Anvin wrote:

> On 09/27/2012 12:02 AM, Alex Shi wrote:
>>
>> Peter:
>>
>> Maybe the patch doesn't looks perfect for this issue.
>> So I am wondering if the following patch is better, if we don't care
>> the irq_tlb
>> was counted again in irq_call?
>>
> 
> Tomoki-san's patch looked sane to me, I should just apply it.
> 
>     -hpa
> 


Glad to see this! :)

-- 
Thanks
    Alex
