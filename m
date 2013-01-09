Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3AIJMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 04:12:07 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:25734 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab3AIJME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 04:12:04 -0500
Message-ID: <50ED344D.9010307@huawei.com>
Date: Wed, 9 Jan 2013 17:11:41 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] Update PCI notification patchset to latest kernel
 version
References: <CAErSpo4G9FQxh1vPjDDnjYrkfV8MNFvBK-ECMeiPnCVGA5Lgjg@mail.gmail.com> <1357663945-16054-1-git-send-email-jiang.liu@huawei.com> <CAE9FiQUKPcy5B2ThBw1AzNnsUJ9rLHKTJ1xRFO1rRuiFavw-2w@mail.gmail.com>
In-Reply-To: <CAE9FiQUKPcy5B2ThBw1AzNnsUJ9rLHKTJ1xRFO1rRuiFavw-2w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/9 2:30, Yinghai Lu wrote:
> On Tue, Jan 8, 2013 at 8:52 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> Hi Bjorn,
>>         Rafael has developed a patchset targetting 3.9 merging window
>> which outdates the fourth and fifth patches in my previous version,
>> so I have just drop those two patches and updated the others to the
>> latest code from your pci-next branch.
>>         Thanks!
>>
>> Jiang Liu (5):
>>   PCI: make PCI device create/destroy logic symmetric
>>   PCI: split registration of PCI bus devices into two stages
>>   ACPI/pci_slot: update PCI slot information when PCI hotplug event
>>     happens
>>   PCI/acpiphp: update ACPI hotplug slot information when PCI hotplug
>>     happens
>>   PCI/acpiphp: serialize access to the bridge_list list
>>
>> Yijing Wang (1):
>>   PCI/AER: update AER configuration when PCI hotplug event happens
>>
> 
> last time during my test before, looks there are some problems with last four.

Hi Yinghai,
   I will test the patchset again. Do you remember what problems occur during test the last four patches?
So I can try to find out the flaw.

Thanks!
Yijing.
> 
> so I only put first two in my pci root bus hotplug branch.
> 
> maybe my memory is wrong. too long for those patches till now.
> 
> 


-- 
Thanks!
Yijing

