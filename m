Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab0FIAyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 20:54:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42063 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab0FIAyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 20:54:00 -0400
Message-ID: <4C0EE5FF.5080003@zytor.com>
Date: Tue, 08 Jun 2010 17:53:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jacob Pan <jacob.jun.pan@intel.com>,
       Tejun Heo <tj@kernel.org>, Mike Habeck <habeck@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com>	<201006011649.56074.bjorn.helgaas@hp.com>	<4C0608C6.4090901@zytor.com>	<201006020945.09107.bjorn.helgaas@hp.com>	<4C067D0B.7030804@zytor.com> <20100602085327.71dfaca0@virtuousgeek.org>
In-Reply-To: <20100602085327.71dfaca0@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 08:53 AM, Jesse Barnes wrote:
>>
>> That's what I thought, which I guess means my original question to Mike 
>> still stands...
> 
> I thought the whole reason for this was hotplug; we don't want to
> exhaust I/O space unnecessarily by allocating resources for BARs the
> BIOS didn't assign so we can keep them around for later hotplug
> activity.
> 
> If there's some other issue, it's not too late to drop this patch.
> 

Okay, now... this means that if a device that the BIOS doesn't know
about, but which needs I/O addresses, then it will work if hotplugged,
but not if it is plugged in on system boot?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

