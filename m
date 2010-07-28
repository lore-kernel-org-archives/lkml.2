Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0G1Tco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:32:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18623 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab0G1Tcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:32:41 -0400
Message-ID: <4C508577.70802@kernel.org>
Date: Wed, 28 Jul 2010 12:31:03 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Corey Minyard <minyard@acm.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Myron Stowe <myron.stowe@hp.com>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: Fix ACPI detecting with regspacing
References: <4C4E0292.4010004@kernel.org>	<201007271123.44335.bjorn.helgaas@hp.com>	<4C4F173C.1010406@kernel.org>	<201007271141.10933.bjorn.helgaas@hp.com> <20100728122223.b753f586.akpm@linux-foundation.org>
In-Reply-To: <20100728122223.b753f586.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C50859D.005A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 12:22 PM, Andrew Morton wrote:
> On Tue, 27 Jul 2010 11:41:10 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
>> On Tuesday, July 27, 2010 11:28:28 am Yinghai Lu wrote:
>>> On 07/27/2010 10:23 AM, Bjorn Helgaas wrote:
>>>> On Tuesday, July 27, 2010 11:07:55 am Yinghai Lu wrote:
>>>>> On 07/27/2010 08:34 AM, Bjorn Helgaas wrote:
>>>>>> On Monday, July 26, 2010 03:48:02 pm Yinghai Lu wrote:
>>>>>>>
>>>>>>> after the commint that change ipmi_si detecting sequence from SMBIOS/ACPI to ACPI/SMBIOS,
>>>>>>>
>>>>>>> | commit 754d453185275951d39792865927ec494fa1ebd8
>>>>>>> | Author: Matthew Garrett <mjg@redhat.com>
>>>>>>> | Date:   Wed May 26 14:43:47 2010 -0700
>>>>>>> |
>>>>>>> |    ipmi: change device discovery order
>>>>>>> |
>>>>>>> |    The ipmi spec provides an ordering for si discovery.  Change the driver to
>>>>>>> |    match, with the exception of preferring smbios to SPMI as HPs (at least)
>>>>>>> |    contain accurate information in the former but not the latter.
>>>>>>>
>>>>>>> ipmi_si can not be initialized.
>>>>>>
>>>>>> I think this patch makes sense, as long as this is not a bringup
>>>>>> issue that only affects pre-release firmware.  If this only affects
>>>>>> a prototype, it would be better to change the firmware so it conforms
>>>>>> to the conventional _CRS usage of systems in the field.
>>>>>>
>>>>>> To that end, I'd like to know what system this is, and whether IPMI
>>>>>> works under Windows on this system.  We know that Windows doesn't
>>>>>> look at SMBIOS or SPMI, so if Windows works, it must be doing something
>>>>>> similar to your patch.
>>>>>
>>>>> Sun Fire X4800.
>>>>>
>>>>> Yes. other OSes work and pass certification.
>>>>
>>>> Please put this information in the changelog (if that wasn't obvious).
>>>
>>> I don't want to mention other os.
>>
>> Sigh.  Why is this so difficult?
> 
> It wasn't for me ;)
> 
> Do we have acks for 2.6.36 and a -stable backport on this patch?

Matthew Garrett <mjg@redhat.com>
gave ack to it.

looks like Matthew's patch only get into 2.6.35.

So we need it for 2.6.35 and later.

Thanks

Yinghai

