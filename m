Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab0F3WEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:04:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:6052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab0F3WEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:04:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,515,1272870000"; 
   d="scan'208";a="581597149"
Message-ID: <4C2BBF7C.20004@intel.com>
Date: Wed, 30 Jun 2010 15:04:44 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Chris Li <lkml@chrisli.org>
CC: "Woodhouse, David" <david.woodhouse@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>	<4C29420D.2010406@intel.com>	<AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>	<4C2A8879.8010000@intel.com>	<AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>	<4C2AC55E.3040303@intel.com>	<AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>	<1277923422.16256.8.camel@localhost>	<4C2B9DAC.1030806@intel.com>	<1277928125.18854.0.camel@localhost>	<4C2BBACF.3080405@intel.com> <AANLkTil5fCb9maq5qE-2txxaybGqVQSWEy8q0ppBsype@mail.gmail.com>
In-Reply-To: <AANLkTil5fCb9maq5qE-2txxaybGqVQSWEy8q0ppBsype@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/2010 2:59 PM, Chris Li wrote:
> On Wed, Jun 30, 2010 at 2:44 PM, Dan Williams<dan.j.williams@intel.com>  wrote:
>>
>> Chris, is there a BIOS update available for your platform?
>
> You mean the EFI firmware update? Nope.
>
> Do you think loading linux via EFI instead of boot camp (BIOS) will help?
>

...only if the EFI boot process hands Linux a correct (i.e. complete) 
DMAR table.  I suspect native EFI and legacy BIOS boot would still end 
up passing the same table, but I don't know for sure.

--
Dan
