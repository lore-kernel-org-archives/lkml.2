Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab2IUWtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:49:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51378 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab2IUWtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:49:40 -0400
Message-ID: <505CEEF6.1050205@ti.com>
Date: Fri, 21 Sep 2012 18:49:26 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>,
        <grant.likely@secretlab.ca>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v3 17/17] ARM: mm: clean up membank size limit checks
References: <1347385155-11643-1-git-send-email-cyril@ti.com> <1347385155-11643-18-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1209211441520.6667@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1209211441520.6667@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/2012 2:42 PM, Nicolas Pitre wrote:
> On Tue, 11 Sep 2012, Cyril Chemparathy wrote:
>
>> This patch cleans up the highmem sanity check code by simplifying the range
>> checks with a pre-calculated size_limit.  This patch should otherwise have no
>> functional impact on behavior.
>>
>> This patch also removes a redundant (bank->start < vmalloc_limit) check, since
>> this is already covered by the !highmem condition.
>>
>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>
> Acked-by: Nicolas Pitre <nico@linaro.org>
>

Thanks, Nico.

Could you please take another peek at patch 05/17 (support 64-bit 
virt_to_phys patching)?  You had reviewed it in an earlier posting, but 
I've had to tweak the code to optimize the compiler generated inline 
expansion code.

Patch 14/17 (accomodate >32-bit addresses for page table base) could use 
some attention as well.  The same goes with 12/17 (define 
ARCH_LOW_ADDRESS_LIMIT for bootmem), if you could.

-- 
Thanks
- Cyril
