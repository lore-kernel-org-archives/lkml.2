Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0FBHbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:31:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40440 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab0FBHbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:31:51 -0400
Message-ID: <4C0608C6.4090901@zytor.com>
Date: Wed, 02 Jun 2010 00:31:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
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
References: <4BEAF008.9030805@sgi.com> <4C0021DC.60608@zytor.com> <4C039980.3020608@sgi.com> <201006011649.56074.bjorn.helgaas@hp.com>
In-Reply-To: <201006011649.56074.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 03:49 PM, Bjorn Helgaas wrote:
>>
>> BIOS still assigns the MMIO BAR's so the devices are alive.
>
> I'm sorry; I don't follow this.  BIOS assigns MMIO BARs regardless
> of whether we have your patch.
>

I'm assuming that that Mike is implying is that the allocation code runs 
out of I/O space and as a result shuts down the entire device.

	-hpa
