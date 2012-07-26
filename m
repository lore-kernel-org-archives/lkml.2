Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab2GZFRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 01:17:49 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:42167
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067Ab2GZFRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 01:17:47 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I936eI1432I4015Izz1202hzz8275eh8275bha1495iz2dh668h839h93fhd25he5bhf0ah107ah)
X-WSS-ID: 0M7R5D1-01-AKD-02
X-M-MSG: 
Message-ID: <5010D2DD.9060201@amd.com>
Date: Thu, 26 Jul 2012 13:17:17 +0800
From: Aaron Lu <aaron.lu@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Jeff Garzik <jgarzik@pobox.com>, <linux-scsi@vger.kernel.org>,
        Lin Ming <minggr@gmail.com>, <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20120725203551.GA19762@havoc.gtf.org>  <50106747.8070501@pobox.com> <5010CBFA.8020907@amd.com> <1343279108.3115.4.camel@dabdike>
In-Reply-To: <1343279108.3115.4.camel@dabdike>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jul 2012 05:17:20.0023 (UTC) FILETIME=[EE3AB270:01CD6AED]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 01:05 PM, James Bottomley wrote:
> On Thu, 2012-07-26 at 12:47 +0800, Aaron Lu wrote:
>> On 07/26/2012 05:38 AM, Jeff Garzik wrote:
>>> On 07/25/2012 04:35 PM, Jeff Garzik wrote:
>>>> * Updating libata to directly bind with ACPI / runtime power mgmt.
>>>> This is a pre-req for SATA ZPODD (CD-ROM power management).
>>>>
>>>> Touches ACPI (exports++) and SCSI in minor ways. Has been in linux-next
>>>> for weeks.
>>>>
>>>> The rest of [ZPODD] will probably come via SCSI tree, as it involves
>>>> a lot of updates to the 'sr' driver etc.
>>>
>>> BTW Lin and Aaron, note that this did not include these changes:
>>>
>>> sr: check support for device busy class events
>>> sr: support zero power ODD
>>> sr: make sure ODD is in resumed state in block ioctl
>>>
>>> as in the end I wanted to put the brakes on SCSI-touching patches. These
>>> should be able to go into James' scsi-misc tree with the other SCSI-area
>>> ZPODD changes.
>>>
>>> For those three 'sr' changes listed above, you may add
>>>
>>> Acked-by: Jeff Garzik<jgarzik@redhat.com>
>>>
>>> when moving them over.
>>
>> Thanks Jeff.
>>
>> Hi James,
>> I'll prepare these dropped patches plus some other fixes for ZPODD which
>> I've sent v2 recently and merge them into v3 for you to review.
>
> They weren't exactly dropped ... I've been waiting for you to address
> Alan Stern's comments, since he's our resident expert on suspend/resume.

Oh, I forgot to mention, that I agree with Alan's comments and have
addressed them in my v2 patches here:
http://marc.info/?l=linux-scsi&m=134312317325650&w=2

The 2 patches Alan has comments are:
http://marc.info/?l=linux-scsi&m=134312311025619&w=2
http://marc.info/?l=linux-scsi&m=134312308225610&w=2

Hi Alan,
Are the v2 patches look OK to you?

And James,
Do you want me to rebase these patches on top of scsi-misc tree?

Thanks,
Aaron

