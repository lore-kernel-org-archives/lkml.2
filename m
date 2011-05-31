Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1EaPBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:01:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50159 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1EaPBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:01:06 -0400
Date: Tue, 31 May 2011 10:01:00 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@sleepy
To: Chris Ball <cjb@laptop.org>
cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, philipl@overt.org,
        w.sang@pengutronix.de
Subject: Re: [PATCH] mmc: Enable MMC card reader for RICOH [1180:e823]
In-Reply-To: <m3fwo0u9sf.fsf@pullcord.laptop.org>
Message-ID: <alpine.DEB.2.02.1105310958460.4067@sleepy>
References: <1306426745-3636-1-git-send-email-manoj.iyer@canonical.com> <1306426745-3636-2-git-send-email-manoj.iyer@canonical.com> <m3fwo0u9sf.fsf@pullcord.laptop.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 26 May 2011, Chris Ball wrote:

> Hi Manoj,
>
> On Thu, May 26 2011, Manoj Iyer wrote:
>> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
>> ---
>>  drivers/pci/quirks.c    |    2 ++
>>  include/linux/pci_ids.h |    1 +
>>  2 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index e8a1406..02145e9 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -2761,6 +2761,8 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
>>  }
>>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
>>  DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE823, ricoh_mmc_fixup_r5c832);
>> +DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5CE823, ricoh_mmc_fixup_r5c832);
>>  #endif /*CONFIG_MMC_RICOH_MMC*/
>>
>>  #if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
>> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
>> index 24787b7..2269dac 100644
>> --- a/include/linux/pci_ids.h
>> +++ b/include/linux/pci_ids.h
>> @@ -1537,6 +1537,7 @@
>>  #define PCI_DEVICE_ID_RICOH_RL5C476	0x0476
>>  #define PCI_DEVICE_ID_RICOH_RL5C478	0x0478
>>  #define PCI_DEVICE_ID_RICOH_R5C822	0x0822
>> +#define PCI_DEVICE_ID_RICOH_R5CE823	0xe823
>>  #define PCI_DEVICE_ID_RICOH_R5C832	0x0832
>>  #define PCI_DEVICE_ID_RICOH_R5C843	0x0843
>
> Do you not need a corresponding entry in drivers/mmc/host/sdhci-pci.c's
> pci_device_id struct?
>

I believe there is an entry there already, introduced by this patch:
https://lkml.org/lkml/2011/2/11/309

> Thanks,
>
> - Chris.
> -- 
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
