Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041Ab0ENWkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:40:19 -0400
Received: from relay1.sgi.com ([192.48.179.29]:46142 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759291Ab0ENWkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:40:17 -0400
Message-ID: <4BEDD14A.1030400@sgi.com>
Date: Fri, 14 May 2010 15:40:10 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Mike Habeck <habeck@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jacob Pan <jacob.jun.pan@intel.com>,
       Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com>	<201005131256.17997.bjorn.helgaas@hp.com>	<4BEC5530.1000008@sgi.com>	<201005131402.30759.bjorn.helgaas@hp.com> <20100514152509.3aeb37b4@virtuousgeek.org> <4BEDCFD9.7020202@sgi.com> <4BEDD03B.30106@zytor.com>
In-Reply-To: <4BEDD03B.30106@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:
> On 05/14/2010 03:34 PM, Mike Travis wrote:
>> It seems that BIOS changes are much more difficult.  The real solution
>> to this problem is for Card Vendors to not request I/O Bars if they
>> won't be using them.  But that's the hardest option of all to accomplish.
>>
> 
> That is a non-option.  Any device which may have to be a boot or console
> device in a legacy system pretty much needs them.
> 
> 	-hpa

Yes, that's true.  We're somewhat fortunate in that our Legacy I/O
devices are confined to those on the first blade, and all of these
other devices are on other blades (PCI segments 1+).

But you're right, unless the card vendor supplied some kind of strapping
option, or something similar, it won't know it's in a UV system or not.

Thanks,
Mike
