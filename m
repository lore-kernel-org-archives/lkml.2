Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab0FBPrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:47:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58418 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757995Ab0FBPrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:47:52 -0400
Message-ID: <4C067D0B.7030804@zytor.com>
Date: Wed, 02 Jun 2010 17:47:23 +0200
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       Mike Habeck <habeck@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com> <201006011649.56074.bjorn.helgaas@hp.com> <4C0608C6.4090901@zytor.com> <201006020945.09107.bjorn.helgaas@hp.com>
In-Reply-To: <201006020945.09107.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 05:45 PM, Bjorn Helgaas wrote:
> On Wednesday, June 02, 2010 01:31:18 am H. Peter Anvin wrote:
>> On 06/01/2010 03:49 PM, Bjorn Helgaas wrote:
>>>>
>>>> BIOS still assigns the MMIO BAR's so the devices are alive.
>>>
>>> I'm sorry; I don't follow this.  BIOS assigns MMIO BARs regardless
>>> of whether we have your patch.
>>
>> I'm assuming that that Mike is implying is that the allocation code runs
>> out of I/O space and as a result shuts down the entire device.
>
> Yeah, that's why I asked about a deeper problem.  There's not really a
> "shut down this device" flag, so the only way I can think of that we
> might make a device completely unusable is if we release all the device
> resources and then fail to reassign them.
>
> A concrete example, e.g., a dmesg log, would go a long ways toward
> clarifying this.
>

That's what I thought, which I guess means my original question to Mike 
still stands...

	-hpa

