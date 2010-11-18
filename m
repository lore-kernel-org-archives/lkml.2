Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0KRIaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:30:35 -0500
Received: from smtpauth.net4india.com ([118.67.248.47]:35331 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0KRIae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:30:34 -0500
Message-ID: <4CE4E41C.7020202@xenontk.org>
Date: Thu, 18 Nov 2010 14:00:20 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.2.12) Gecko/20101103 Thunderbird/3.1.6
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.37-rc1 / rc2 Regression] PCI: Kernel Hangs On Boot
References: <4CE3F763.6080002@xenontk.org> <20101117192449.GA12191@helgaas.com>
In-Reply-To: <20101117192449.GA12191@helgaas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 12:54 AM, Bjorn Helgaas wrote:
> On Wed, Nov 17, 2010 at 09:10:19PM +0530, David John wrote:
>> Commit dc9887dc ("x86/PCI: allocate space from the end of a region, not
>> the beginning") causes the kernel to hang on my Dell Inspiron 1545.
>> 2.6.36 and booting with pci=nocrs works fine. Reverting this commit also
>> works. I am attaching the kernel log and system iomem from the working
>> 2.6.36. It hangs at this location consistently:
>>
>> pci-stub: invalid id string ""
>> ACPI: AC Adapter [AC] (on-line)
>> input: Lid Switch as
>> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
>>
>> < hang >
>>
>> Let me know if you need any other info.
> 
> Thanks a lot for this report.  I opened this bugzilla:
>     https://bugzilla.kernel.org/show_bug.cgi?id=23132
> to track it.
> 
> Would you mind attaching the dmesg log from 2.6.37-rc2 with
> commit dc9887dc reverted?  That should have a little more
> information (PCI allocation closer to what fails, and also
> more PNP resource information).

Attached in Bugzilla.

> If you happen to have Windows on this box as well, an
> Everest report (http://lavalys.com) would be interesting.
> If not, no worries.

Nope, no Windows on this box, Sorry.

Regards,
David.
