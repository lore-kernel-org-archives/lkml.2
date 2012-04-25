Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab2DYRR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:17:26 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48924 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753451Ab2DYRRZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:17:25 -0400
MIME-Version: 1.0
In-Reply-To: <1333905129-8776-1-git-send-email-jiang.liu@huawei.com>
References: <20120406115948.3536e6c8.izumi.taku@jp.fujitsu.com> <1333905129-8776-1-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 Apr 2012 11:17:03 -0600
Message-ID: <CAErSpo6T0bzpWV_4scgr80nvoLDqvXqFbnqUSPyhO+W94TH7Pg@mail.gmail.com>
Subject: Re: [PATCH RFC 0/2] PCI, x86: update MMCFG information when
 hot-plugging PCI host bridges
To: Jiang Liu <liuj97@gmail.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 11:12 AM, Jiang Liu <liuj97@gmail.com> wrote:
> This patchset enhance pci_root driver to update MMCFG information when
> hot-plugging PCI root bridges. It applies to Yinghai's tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug
>
> The second patch is based on Taku Izumi work with some enhancements to
> correctly handle PCI host bridges without _CBA method.
>
> Jiang Liu (2):
>  PCI,x86: introduce new MMCFG interfaces to support PCI host bridge
>    hotplug
>  PCI, ACPI, x86: update MMCFG information when hot-plugging PCI host
>    bridges
>
>  arch/x86/include/asm/pci_x86.h |    4 +
>  arch/x86/pci/acpi.c            |   58 +++++++++++++
>  arch/x86/pci/mmconfig-shared.c |  186 +++++++++++++++++++++++++++++++---------
>  arch/x86/pci/mmconfig_32.c     |   28 ++++++-
>  arch/x86/pci/mmconfig_64.c     |   35 +++++++-
>  drivers/acpi/pci_root.c        |   20 +++++
>  include/acpi/acnames.h         |    1 +
>  include/linux/pci-acpi.h       |    3 +
>  8 files changed, 288 insertions(+), 47 deletions(-)

Jiang, I assume this series is superceded by "[PATCH V4 0/6] PCI, x86:
update MMCFG information when hot-plugging PCI host bridges".  Let me
know if that's incorrect.

Bjorn
