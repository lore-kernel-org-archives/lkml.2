Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1GGT6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:58:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:60879 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab1GGT6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:58:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,495,1304319600"; 
   d="scan'208";a="24612955"
Message-ID: <4E16100F.5030005@linux.intel.com>
Date: Thu, 07 Jul 2011 12:59:11 -0700
From: J Freyensee <james_p_freyensee@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, christophe.guerard@intel.com,
        pranav.k.sanghadia@intel.com
Subject: Re: [PATCH] Add PCI config dependency for PTI.
References: <james_p_freyensee@linux.intel.com> <1310066653-26879-1-git-send-email-james_p_freyensee@linux.intel.com> <20110707123154.d6fb4a99.randy.dunlap@oracle.com>
In-Reply-To: <20110707123154.d6fb4a99.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 12:31 PM, Randy Dunlap wrote:
> On Thu,  7 Jul 2011 12:24:13 -0700 james_p_freyensee@linux.intel.com wrote:
>
>> From: J Freyensee<james_p_freyensee@linux.intel.com>
>>
>> Intel-Atom implementation of PTI will not work with PCI
>> configured off, so the pti driver should not be compiled
>> in the event someone does not enable PCI in the linux kernel.
>>
>> Signed-off-by: J Freyensee<james_p_freyensee@linux.intel.com>
>> Acked-by: Randy Dunlap<randy.dunlap@oracle.com>
> now you can say that above. ^^^
So you want me to stick the 'Acked-by' and 'Reported-by' above the 
Signed-off-by line?

> Also
> Reported-by: Randy Dunlap<randy.dunlap@oracle.com>
>
> Thanks.
>
>> Acked-by: Stephen Rothwell<sfr@canb.auug.org.au>
>> ---
>>   drivers/misc/Kconfig |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
>> index 4e349cd..7fd32a6 100644
>> --- a/drivers/misc/Kconfig
>> +++ b/drivers/misc/Kconfig
>> @@ -146,6 +146,7 @@ config PHANTOM
>>
>>   config INTEL_MID_PTI
>>   	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
>> +	depends on PCI
>>   	default n
>>   	help
>>   	  The PTI (Parallel Trace Interface) driver directs
>> -- 
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

