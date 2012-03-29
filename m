Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135Ab2C2LS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:18:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54550 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2C2LSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:18:20 -0400
MIME-Version: 1.0
In-Reply-To: <4F744412.4090806@mvista.com>
References: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
	<1332915722-15963-5-git-send-email-ming.m.lin@intel.com>
	<4F72F45D.7090800@mvista.com>
	<1332997594.3793.118.camel@minggr>
	<4F744412.4090806@mvista.com>
Date: Thu, 29 Mar 2012 19:18:19 +0800
X-Google-Sender-Auth: dhaO9zIwuERMHxcBfol3b3MHOQU
Message-ID: <CAF1ivSZdFpd1v15Q+fVkiGZSp_oGT-rLj0K_5AxfC7yADed=hA@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] libata: detech Device Attention support
From: Lin Ming <ming.m.lin@intel.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@amd.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 7:14 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
>
> On 29-03-2012 9:06, Lin Ming wrote:
>
>>>> Add a new flag ATA_DFLAG_DA to indicate that device supports "Device
>>>> Attention".
>
>
>>>> Acked-by: Aaron Lu<aaron.lu@amd.com>
>>>> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
>>>
>>> [...]
>
>
>>>> diff --git a/include/linux/ata.h b/include/linux/ata.h
>>>> index 32df2b6..6ee41cc 100644
>>>> --- a/include/linux/ata.h
>>>> +++ b/include/linux/ata.h
>>>> @@ -578,6 +578,7 @@ static inline int ata_is_data(u8 prot)
>>>>          ((u64) (id)[(n) + 0]) )
>>>>
>>>>   #define ata_id_cdb_intr(id)  (((id)[ATA_ID_CONFIG]&   0x60) == 0x20)
>>>> +#define atapi_id_has_da(id)    ((id)[77]&   (1<<   4))
>
>
>>>     We prefix these macros with 'ata_' despite them being applied to
>>> IDENTIFY
>>> DEVICE data or IDENTIFY PAKCET DEVICE data. ata_id_cdb_intr(), for
>>> example,
>>> applies only to IDENTIFY PAKCET DEVICE data.
>
>
>> OK, will change it.
>
>
>   Also, what does the word "detech" mean in the subject?

Typo! It should be "detect"

>
>
> MBR, Sergei
