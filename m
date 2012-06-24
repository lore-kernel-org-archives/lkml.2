Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2FXCrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 22:47:37 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57119 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2FXCre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 22:47:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7DxKLJC4p1n1YS3HNpjdeXvYTLL-_tkWqu_2yWokLttw@mail.gmail.com>
References: <1340418231-10134-1-git-send-email-ying.huang@intel.com>
	<CAErSpo7DxKLJC4p1n1YS3HNpjdeXvYTLL-_tkWqu_2yWokLttw@mail.gmail.com>
Date: Sun, 24 Jun 2012 10:47:33 +0800
Message-ID: <CAC=cRTO1LFzWWCXLGXvtLdwWKUjV9Z4r=shE6UN8UAW1PnZHag@mail.gmail.com>
Subject: Re: [PATCH -v7 0/4] PCIe, PM, Add PCIe runtime D3cold support
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

On Sun, Jun 24, 2012 at 5:26 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Jun 22, 2012 at 8:23 PM, Huang Ying <ying.huang@intel.com> wrote:
>> Changelog:
>>
>> v7:
>>
>> - Rebased on pci.git next branch
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
>> [PATCH -v7 1/4] ACPI, PM, Specify lowest allowed state for device sleep
>> [PATCH -v7 2/4] PCIe, PM, Add runtime PM support to PCIe port
>> [PATCH -v7 3/4] PCI, do not call pci_set_power_state with PCI_D3cold
>> [PATCH -v7 4/4] PCIe, PM, Add PCIe runtime D3cold support
>
> I merged this to my "next" branch and pushed it.  Thanks!
>
> I reworded some of the [4/4] changelog -- check it over and make sure
> it still makes sense:
>
> http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=commit;h=448bd857d48e69b33ef323739dc6d8ca20d4cda7

Thanks.  Your version is much better than my original one.

Best Regards,
Huang Ying
