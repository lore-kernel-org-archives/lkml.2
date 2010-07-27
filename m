Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab0G0RIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:08:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44729 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0G0RIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:08:44 -0400
Message-ID: <4C4F126B.8050309@kernel.org>
Date: Tue, 27 Jul 2010 10:07:55 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Corey Minyard <minyard@acm.org>, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Myron Stowe <myron.stowe@hp.com>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: Fix ACPI detecting with regspacing
References: <4C4E0292.4010004@kernel.org> <201007270934.45683.bjorn.helgaas@hp.com>
In-Reply-To: <201007270934.45683.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C4F127A.00E1,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 08:34 AM, Bjorn Helgaas wrote:
> On Monday, July 26, 2010 03:48:02 pm Yinghai Lu wrote:
>>
>> after the commint that change ipmi_si detecting sequence from SMBIOS/ACPI to ACPI/SMBIOS,
>>
>> | commit 754d453185275951d39792865927ec494fa1ebd8
>> | Author: Matthew Garrett <mjg@redhat.com>
>> | Date:   Wed May 26 14:43:47 2010 -0700
>> |
>> |    ipmi: change device discovery order
>> |
>> |    The ipmi spec provides an ordering for si discovery.  Change the driver to
>> |    match, with the exception of preferring smbios to SPMI as HPs (at least)
>> |    contain accurate information in the former but not the latter.
>>
>> ipmi_si can not be initialized.
> 
> I think this patch makes sense, as long as this is not a bringup
> issue that only affects pre-release firmware.  If this only affects
> a prototype, it would be better to change the firmware so it conforms
> to the conventional _CRS usage of systems in the field.
> 
> To that end, I'd like to know what system this is, and whether IPMI
> works under Windows on this system.  We know that Windows doesn't
> look at SMBIOS or SPMI, so if Windows works, it must be doing something
> similar to your patch.

Sun Fire X4800.

Yes. other OSes work and pass certification.

Thanks

Yinghai
