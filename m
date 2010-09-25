Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab0IYAO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 20:14:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49893 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab0IYAO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 20:14:27 -0400
Message-ID: <4C9D3E8B.7090000@kernel.org>
Date: Fri, 24 Sep 2010 17:12:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Prarit Bhargava <prarit@redhat.com>, fredlwm@gmail.com,
        Simon Arlott <simon@fire.lp0.eu>, x86@kernel.org,
        Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Marc Jones <marcj303@gmail.com>,
        Jordan Crouse <jcrouse@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, HPET: mark HPET PCI BARs as IORESOURCE_PCI_FIXED
References: <20100923233047.12463.61480.stgit@bob.kio>	<201009241706.11742.bjorn.helgaas@hp.com> <AANLkTi=GrH4fR_wSFytaSiXsH+wo2a=DaLAU4H2d0d1M@mail.gmail.com> <4C9D3D79.9060908@zytor.com>
In-Reply-To: <4C9D3D79.9060908@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 05:08 PM, H. Peter Anvin wrote:
> On 09/24/2010 04:59 PM, Yinghai Lu wrote:
>> On Fri, Sep 24, 2010 at 4:06 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>> Sorry Yinghai, I forgot to copy you on the initial post.  Any
>>> comments on this?  If not, we should try to get it into linux-next
>>> soon.
>>
>> should be good.
>>
>> only one thing, that will punish all other vendors... and run that
>> quirk for every pci device.
>>
>> please check if you can have
>> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_ANY_ID, mark_pci_hpet_fixed);
>>
>> AND _AMD maybe, if AMD dump _ATI brand later.
>>
> 
> No, because the problem is known to happen on multiple vendors.
> 
Do you have URL to them?

INTEL ?
ServerWorks?
Via?

Yinghai
