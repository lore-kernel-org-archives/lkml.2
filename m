Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1KUTLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:11:45 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3044 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab1KUTLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:11:44 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Michael Lewis" <miclewis@broadcom.com>
To: "Matthew Dharm" <mdharm-usb@one-eyed-alien.net>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Nov 2011 11:11:30 -0800
Subject: RE: [PATCH] usb: noted broken URL link in usb.c description
Thread-Topic: [PATCH] usb: noted broken URL link in usb.c description
Thread-Index: AcyogHOV/2Utx44gToCgrJjTXsIvcgAANAcg
Message-ID: <3530313B48D5704B86CF382E8866C7F9AE16A00D0C@IRVEXCHCCR02.corp.ad.broadcom.com>
References: <3530313B48D5704B86CF382E8866C7F9AE0F34D0B4@IRVEXCHCCR02.corp.ad.broadcom.com>
 <CAA6KcBC6AgZJYZtCWcZ1aS6xACSOWy_8GVzq9sEr8Ozou8oT_A@mail.gmail.com>
 <3530313B48D5704B86CF382E8866C7F9AE0F58E420@IRVEXCHCCR02.corp.ad.broadcom.com>
 <CAA6KcBC0DXTaTHb-opd_HyTa91=XeuuHi-PFi+gqKxOurY9W1g@mail.gmail.com>
 <CAA6KcBBdFrm3kKXO9t7tTSxF4S=jkypZfU-REQv7rKGhN0Wbiw@mail.gmail.com>
In-Reply-To: <CAA6KcBBdFrm3kKXO9t7tTSxF4S=jkypZfU-REQv7rKGhN0Wbiw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 62D47BCE5WO1592664-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for fixing this, Matt.

- Mike


-----Original Message-----
From: Matthew Dharm [mailto:mdharm-usb@one-eyed-alien.net] 
Sent: Monday, November 21, 2011 11:04 AM
To: Michael Lewis
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: noted broken URL link in usb.c description

The page is back up, so we can discard this patch completely.

Matt

On Mon, Nov 14, 2011 at 12:31 PM, Matthew Dharm
<mdharm-usb@one-eyed-alien.net> wrote:
> Well, it hasn't been updated since 2008, but it still used to get hit
> periodically before I shutdown the server several months ago.
>
> Let me see about moving the whopping 2 HTML files, one TXT file, and
> one PNG to a different server within the organization... if it doesn't
> happen in a few days, we should just take out all references to that
> URL, not just mark it as a dead link.
>
> Matt
>
> On Mon, Nov 14, 2011 at 12:28 PM, Michael Lewis <miclewis@broadcom.com> wrote:
>> Sure, that's fine. I didn't know if you were still actively maintaining it or not.
>>
>> Thanks,
>> - Mike
>>
>>
>> -----Original Message-----
>> From: Matthew Dharm [mailto:mdharm-usb@one-eyed-alien.net]
>> Sent: Monday, November 14, 2011 12:25 PM
>> To: Michael Lewis
>> Cc: linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] usb: noted broken URL link in usb.c description
>>
>> A fair point.  I should get around to fixing that.  Why don't we
>> hold-off on the patch and let me work on this for a couple of days?
>>
>> Matt
>>
>> On Mon, Nov 14, 2011 at 12:14 PM, Michael Lewis <miclewis@broadcom.com> wrote:
>>> From ca036284fdc2a6801fab566c2218307235518876 Mon Sep 17 00:00:00 2001
>>> From: Michael Lewis <miclewis@broadcom.com>
>>> Date: Mon, 14 Nov 2011 11:47:42 -0800
>>> Subject: [PATCH] usb: noted broken URL link in usb.c description
>>>
>>>
>>> Signed-off-by: Michael Lewis <miclewis@broadcom.com>
>>> ---
>>>  drivers/usb/storage/usb.c |    3 ++-
>>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
>>> index aa84b3d..33cf6ad 100644
>>> --- a/drivers/usb/storage/usb.c
>>> +++ b/drivers/usb/storage/usb.c
>>> @@ -28,7 +28,8 @@
>>>  * status of a command.
>>>  *
>>>  * Please see http://www.one-eyed-alien.net/~mdharm/linux-usb for more
>>> - * information about this driver.
>>> + * information about this driver. Note, URL link is dead and needs
>>> + * to be fixed.
>>>  *
>>>  * This program is free software; you can redistribute it and/or modify it
>>>  * under the terms of the GNU General Public License as published by the
>>> --
>>> 1.7.1
>>>
>>>
>>
>>
>>
>> --
>> Matthew Dharm
>> Maintainer, USB Mass Storage driver for Linux
>>
>>
>>
>
>
>
> --
> Matthew Dharm
> Maintainer, USB Mass Storage driver for Linux
>



-- 
Matthew Dharm
Maintainer, USB Mass Storage driver for Linux


