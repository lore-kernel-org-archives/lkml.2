Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab2HPPPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:15:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63479 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab2HPPP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:15:28 -0400
Message-ID: <502D0E79.9000103@gmail.com>
Date: Thu, 16 Aug 2012 23:15:05 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <jiang.liu@huawei.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>, Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Resend with Ack][PATCH v1] PCI: allow acpiphp to handle PCIe
 ports without native PCIe hotplug capability
References: <1338795894-6292-1-git-send-email-jiang.liu@huawei.com> <CAErSpo7ZtHDQNBnreZXsqDqKbqc=O+BKHDM8H0w+QkFep9ydFg@mail.gmail.com>
In-Reply-To: <CAErSpo7ZtHDQNBnreZXsqDqKbqc=O+BKHDM8H0w+QkFep9ydFg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 03:12 AM, Bjorn Helgaas wrote:
> On Mon, Jun 4, 2012 at 1:44 AM, Jiang Liu <jiang.liu@huawei.com> wrote:
>> Commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a (PCI / ACPI: Make acpiphp
>> ignore root bridges using PCIe native hotplug) added code that made the
>> acpiphp driver completely ignore PCIe root complexes for which the kernel
>> had been granted control of the native PCIe hotplug feature by the BIOS
>> through _OSC. Later commit 619a5182d1f38a3d629ee48e04fa182ef9170052
>> "PCI hotplug: Always allow acpiphp to handle non-PCIe bridges" relaxed
>> the constraints to allow acpiphp driver handle non-PCIe bridges under
>> such a complex. The constraint needs to be relaxed further to allow
>> acpiphp driver to hanlde PCIe ports without native PCIe hotplug capability.
> 
> Gerry, I assume you'll refresh and repost this after we get the PCIe
> capability stuff squared away, so I'll ignore this patch for now.
> 
Hi Bjorn,
	Please just ignore it and I will rework it after the PCIe capabilities
patches are done.
	Regards!
	Gerry

