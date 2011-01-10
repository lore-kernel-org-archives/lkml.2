Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1AJULx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:11:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35546 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab1AJULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:11:51 -0500
Message-ID: <4D2B67C8.6010302@kernel.org>
Date: Mon, 10 Jan 2011 12:10:48 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 0/3] x86, usb, pci: Disable usb legacy support early
References: <4D2A1382.7010407@kernel.org>	<20110110155724.GA5275@kroah.com> <20110110102759.3780cfe6@jbarnes-desktop>
In-Reply-To: <20110110102759.3780cfe6@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 10:27 AM, Jesse Barnes wrote:
> On Mon, 10 Jan 2011 07:57:24 -0800
> Greg KH <greg@kroah.com> wrote:
> 
>> On Sun, Jan 09, 2011 at 11:58:58AM -0800, Yinghai Lu wrote:
>>> move quirks for usb handoff early for x86.
>>>
>>> So we can get stable result when trying to calibrate apic timer with pm-timer.
>>
>> Is this a real problem today?  What is the symptom of the issue?  Where
>> was it reported as a problem?
> 
> Yes, please give us a rationale for all this mess.  I really don't like
> the sleep wrappers or the "early" PCI device; would it be easier to
> extract some of the core disabling MMIO from the quirks and re-use it
> for a totally separate set of early quirk functions?  Like Ben
> suggested, making it totally arch specific would be a good option,
> though presumably most arches don't need this

sure, will have new version to address that.

> (again if you explained
> why/when this was needed maybe we could come up with a better
> solution, or just ignore the problem if you're trying to fix a
> pre-production board again with all sorts of broken stuff).
> 

not on pre-production board.

v3 should be clean enough. will send out later.

Thanks

Yinghai
