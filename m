Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab3AHSav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:30:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41606 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab3AHSau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:30:50 -0500
MIME-Version: 1.0
In-Reply-To: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com>
References: <CAErSpo4G9FQxh1vPjDDnjYrkfV8MNFvBK-ECMeiPnCVGA5Lgjg@mail.gmail.com>
	<1357663945-16054-1-git-send-email-jiang.liu@huawei.com>
Date: Tue, 8 Jan 2013 10:30:48 -0800
X-Google-Sender-Auth: Nv1JrL4wbyoKFGT3iNPL5QNLC3Y
Message-ID: <CAE9FiQUKPcy5B2ThBw1AzNnsUJ9rLHKTJ1xRFO1rRuiFavw-2w@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] Update PCI notification patchset to latest kernel version
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 8:52 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Hi Bjorn,
>         Rafael has developed a patchset targetting 3.9 merging window
> which outdates the fourth and fifth patches in my previous version,
> so I have just drop those two patches and updated the others to the
> latest code from your pci-next branch.
>         Thanks!
>
> Jiang Liu (5):
>   PCI: make PCI device create/destroy logic symmetric
>   PCI: split registration of PCI bus devices into two stages
>   ACPI/pci_slot: update PCI slot information when PCI hotplug event
>     happens
>   PCI/acpiphp: update ACPI hotplug slot information when PCI hotplug
>     happens
>   PCI/acpiphp: serialize access to the bridge_list list
>
> Yijing Wang (1):
>   PCI/AER: update AER configuration when PCI hotplug event happens
>

last time during my test before, looks there are some problems with last four.

so I only put first two in my pci root bus hotplug branch.

maybe my memory is wrong. too long for those patches till now.
