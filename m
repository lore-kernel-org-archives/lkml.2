Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab2DMQIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:08:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58972 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab2DMQIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:08:30 -0400
Date: Fri, 13 Apr 2012 11:08:18 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Johan Hedberg <johan.hedberg@gmail.com>
cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] Bluetooth: btusb: Add vendor specific ID (0489 e042)
 for BCM20702A0
In-Reply-To: <20120413092312.GA10780@x220.ger.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1204131106150.3180@lazy>
References: <1333981348-3720-1-git-send-email-manoj.iyer@canonical.com> <1333981348-3720-2-git-send-email-manoj.iyer@canonical.com> <20120413092312.GA10780@x220.ger.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Johan,

I also sent another patch following this one with

Subject	[PATCH] Bluetooth: btusb: Add vendor specific ID (0a5c:21f4) 
BCM20702A0
Date	Wed, 11 Apr 2012 13:39:23 -0500

https://lkml.org/lkml/2012/4/11/358

Just thought I will mention it to you coz both the subject lines look 
similar except for the IDs, sorry about that, the 2nd one was reported 
right after I submitted the 1st patch. Can you please review that as well?

-- manoj

On Fri, 13 Apr 2012, Johan Hedberg wrote:

> Hi Manoj,
>
> On Mon, Apr 09, 2012, Manoj Iyer wrote:
>> T: Bus=02 Lev=02 Prnt=02 Port=04 Cnt=01 Dev#= 3 Spd=12 MxCh= 0
>> D: Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
>> P: Vendor=0489 ProdID=e042 Rev=01.12
>> S: Manufacturer=Broadcom Corp
>> S: Product=BCM20702A0
>> S: SerialNumber=E4D53DCA61B5
>> C: #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
>> I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
>> I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
>> I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
>> I: If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
>>
>> Reported-by: Dennis Chua <dennis.chua@canonical.com>
>> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
>> ---
>>  drivers/bluetooth/btusb.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> Applied to both bluetooth.git and bluetooth-next.git. Thanks.
>
> Johan
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
