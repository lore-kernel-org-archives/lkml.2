Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1HJMCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:02:01 -0400
Received: from smtp.ioda.net ([87.98.140.96]:49427 "EHLO smtp.ioda.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab1HJMCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:02:00 -0400
Message-ID: <4E415E37.2060107@ioda-net.ch>
Date: Tue, 09 Aug 2011 18:20:07 +0200
From: Bruno Friedmann <bruno@ioda-net.ch>
Organization: Ioda-Net =?UTF-8?B?U8Ogcmw=?=
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110729 Thunderbird/6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Mel Gorman <mgorman@suse.de>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Add reboot quirk for Dell Precision M4600
References: <20110727125651.GH3010@suse.de> <20110806065635.GE13220@elte.hu> <20110806153003.GA1238@srcf.ucam.org> <4E40119A.5010803@zytor.com> <4E41197D.30209@ioda-net.ch> <20110809150224.GF28228@elte.hu>
In-Reply-To: <20110809150224.GF28228@elte.hu>
X-Enigmail-Version: 1.3a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2011 05:02 PM, Ingo Molnar wrote:
> 
> * Bruno Friedmann <bruno@ioda-net.ch> wrote:
> 
>> On 08/08/2011 06:40 PM, H. Peter Anvin wrote:
>>> On 08/06/2011 10:30 AM, Matthew Garrett wrote:
>>>> On Sat, Aug 06, 2011 at 08:56:35AM +0200, Ingo Molnar wrote:
>>>>> Weird - ACPI is the default Windows method of reboot - how come it 
>>>>> does not work on that box? Does Windows work around this specific 
>>>>> machine (unlikely), or is our ACPI boot sequence not 100% compatible 
>>>>> with the Windows method (more likely IMO)?
>>>>
>>>> The ACPI reboot method on these machines hits the keyboard controller 
>>>> rather than PCI, which is unusual. What I suspect is that the write 
>>>> triggers some SMM or EC code that's making assumptions about system 
>>>> state, and we're not quite identical. Bouncing on the keyboard 
>>>> controller from userspace with init=/bin/bash wedges in the same way.
>>>>
>>>
>>> I have a vague suspicion that Windows might have a meta-quirk for this
>>> class of machines, i.e. if the ACPI reboot method, say, points at the
>>> keyboard controller or points at the "PCI" reboot port then it actually
>>> uses its own special-purpose routines rather than general routines.  It
>>> would be extremely interesting to know if "reboot=kbd" works on these boxen.
>>>
>>> 	-hpa
>>>
>>
>> Test done with reboot=pci and unfortunately doesn't work.
> 
> Didn't hpa suggest reboot=kbd?
> 
> Thanks,
> 
> 	Ingo

Ingo yeap and reboot=kbd doesn't work ...
I must really be awake before writing

Once the system has synchronised the harddrive, it just stay at now rebooting ...


-- 

Bruno Friedmann
Ioda-Net Sàrl www.ioda-net.ch

openSUSE Member & Ambassador
GPG KEY : D5C9B751C4653227
irc: tigerfoot
