Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab0EOAOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 20:14:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51374 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab0EOAOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 20:14:52 -0400
Message-ID: <4BEDE763.4040802@zytor.com>
Date: Fri, 14 May 2010 17:14:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Mike Travis <travis@sgi.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Mike Habeck <habeck@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com>	<201005131256.17997.bjorn.helgaas@hp.com>	<4BEC5530.1000008@sgi.com>	<201005131402.30759.bjorn.helgaas@hp.com>	<20100514152509.3aeb37b4@virtuousgeek.org>	<4BEDCFD9.7020202@sgi.com>	<20100514154706.4f36f4ed@virtuousgeek.org>	<4BEDDACD.9040704@zytor.com>	<20100514162836.27e0325a@virtuousgeek.org>	<4BEDDD77.1050205@zytor.com>	<20100514163416.0e940f64@virtuousgeek.org>	<4BEDDF4F.3010902@zytor.com> <20100514170004.6577415b@virtuousgeek.org>
In-Reply-To: <20100514170004.6577415b@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 05:00 PM, Jesse Barnes wrote:
> On Fri, 14 May 2010 16:39:59 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> On 05/14/2010 04:34 PM, Jesse Barnes wrote:
>>>> I'm not lamenting that fact, because my experience is that what ends up
>>>> replacing it is often far worse.  Consider UARTs -- no MMU dependencies
>>>> at all, can be accessed with four lines of assembly, and compare it to
>>>> EHCI debug port, the driver for which is over 900 lines in the Linux
>>>> kernel -- and that assumes that you're already in flat mode.
>>>
>>> Heh, you're so old and crufty!
>>
>> I know.  Debugging is so 20th century.
> 
> Yeah, get with the times.  Debugging on today's machines means you have
> to look up register block offsets in ACPI, run some AML to setup your
> debug port, and then load a microkernel onto the debug device to get
> your vnc enabled debug console!
> 

An excellent plan!  Cannot fail!

	-hpa

