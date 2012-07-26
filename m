Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab2GZEsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 00:48:14 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:27277 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868Ab2GZEsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 00:48:11 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I4015Izz1202hzz8275bhz2dh668h839hd25he5bhf0ah107ah)
X-WSS-ID: 0M7R406-01-9L2-02
X-M-MSG: 
Message-ID: <5010CBFA.8020907@amd.com>
Date: Thu, 26 Jul 2012 12:47:54 +0800
From: Aaron Lu <aaron.lu@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, Lin Ming <minggr@gmail.com>,
        <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20120725203551.GA19762@havoc.gtf.org> <50106747.8070501@pobox.com>
In-Reply-To: <50106747.8070501@pobox.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jul 2012 04:48:01.0749 (UTC) FILETIME=[D6376050:01CD6AE9]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 05:38 AM, Jeff Garzik wrote:
> On 07/25/2012 04:35 PM, Jeff Garzik wrote:
>> * Updating libata to directly bind with ACPI / runtime power mgmt.
>> This is a pre-req for SATA ZPODD (CD-ROM power management).
>>
>> Touches ACPI (exports++) and SCSI in minor ways. Has been in linux-next
>> for weeks.
>>
>> The rest of [ZPODD] will probably come via SCSI tree, as it involves
>> a lot of updates to the 'sr' driver etc.
>
> BTW Lin and Aaron, note that this did not include these changes:
>
> sr: check support for device busy class events
> sr: support zero power ODD
> sr: make sure ODD is in resumed state in block ioctl
>
> as in the end I wanted to put the brakes on SCSI-touching patches. These
> should be able to go into James' scsi-misc tree with the other SCSI-area
> ZPODD changes.
>
> For those three 'sr' changes listed above, you may add
>
> Acked-by: Jeff Garzik <jgarzik@redhat.com>
>
> when moving them over.

Thanks Jeff.

Hi James,
I'll prepare these dropped patches plus some other fixes for ZPODD which
I've sent v2 recently and merge them into v3 for you to review.

Thanks,
Aaron

