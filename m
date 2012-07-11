Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab2GKO1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:27:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52449 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2GKO1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:27:45 -0400
Message-ID: <4FFD8D58.6060601@gmail.com>
Date: Wed, 11 Jul 2012 22:27:36 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH 01/14] PCI: add pcie_flags into struct pci_dev to
 cache PCIe capabilities register
References: <1341935655-5381-1-git-send-email-jiang.liu@huawei.com> <1341935655-5381-2-git-send-email-jiang.liu@huawei.com> <20120711180112.3ae76a2e.izumi.taku@jp.fujitsu.com>
In-Reply-To: <20120711180112.3ae76a2e.izumi.taku@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 05:01 PM, Taku Izumi wrote:
>> +++ b/include/linux/pci.h
>> @@ -258,6 +258,7 @@ struct pci_dev {
>>  	u8		pcie_mpss:3;	/* PCI-E Max Payload Size Supported */
>>  	u8		rom_base_reg;	/* which config register controls the ROM */
>>  	u8		pin;  		/* which interrupt pin this device uses */
>> +	u16		pcie_flags;	/* cached PCI-E Capabilities Register */
> 
>  "xxx_flags" sounds like a bit flag. This variable stores a value of PCIe capability 
>  register, doesn't it?   How about "pcie_cap_reg" ?
Hi Taku,
	Good suggestion, will change it.

	Thanks!
	Gerry
