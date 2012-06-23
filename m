Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2FWBFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 21:05:24 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62867 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab2FWBFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 21:05:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4Hd7__n=Ffxk5be1SwVbPZ5PdkaeX4sbAV886PCjSJtg@mail.gmail.com>
References: <1340083249-16266-1-git-send-email-ying.huang@intel.com>
	<CAErSpo4Hd7__n=Ffxk5be1SwVbPZ5PdkaeX4sbAV886PCjSJtg@mail.gmail.com>
Date: Sat, 23 Jun 2012 09:05:21 +0800
Message-ID: <CAC=cRTMBNPUc2eqK5r0hF6grLbOph6j51bAdLxcnZ3KYw4ifdg@mail.gmail.com>
Subject: Re: [PATCH -v6 0/4] PCIe, PM, Add PCIe runtime D3cold support
From: huang ying <huang.ying.caritas@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Huang Ying <ying.huang@intel.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bjorn,

On Sat, Jun 23, 2012 at 6:13 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Jun 18, 2012 at 11:20 PM, Huang Ying <ying.huang@intel.com> wrote:
>> Changelog:
>>
>> v6:
>>
>> - Disable device D3cold during system suspend/hibernate with a new method per Rafeal's comments
>>
>> v5:
>>
>> - Disable device D3cold during system suspend/hibernate per Rafael's comments
>>
>> v4:
>>
>> - Minors fixes based on comments from Rafael
>>
>> v3:
>>
>> - Drop device.power.power_must_be_on, use pci_dev.no_d3cold instead
>> - Drop device.power.power_off_user, use pci_dev.d3cold_allowed instead
>> - Use black list instead of white list in pcie port runtime support per request from Bjorn
>> - Various fixes based on comments from Rafael
>>
>> v2:
>>
>> - Refreshed based on comments from Rafael
>>
>> [PATCH -v6 1/4] ACPI, PM, Specify lowest allowed state for device sleep
>> [PATCH -v6 2/4] PCIe, PM, Add runtime PM support to PCIe port
>> [PATCH -v6 3/4] PCI, PM, Do not call pci_set_power_state with PCI_D3cold
>> [PATCH -v6 4/4] PCIe, PM, Add PCIe runtime D3cold support
>
> What kernel is this series based on?  Patch 4/4 doesn't apply to my
> tree.  This hunk fails because I don't have the "Some devices mustn't
> be in D3 ..." context:

This patchset is based on Linus' tree 3.5-rc3.  I will check with your tree.

Best Regards,
Huang Ying
