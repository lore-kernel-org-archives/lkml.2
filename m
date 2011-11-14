Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1KNUcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 15:32:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50998 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab1KNUcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 15:32:16 -0500
MIME-Version: 1.0
In-Reply-To: <3530313B48D5704B86CF382E8866C7F9AE0F58E420@IRVEXCHCCR02.corp.ad.broadcom.com>
References: <3530313B48D5704B86CF382E8866C7F9AE0F34D0B4@IRVEXCHCCR02.corp.ad.broadcom.com>
 <CAA6KcBC6AgZJYZtCWcZ1aS6xACSOWy_8GVzq9sEr8Ozou8oT_A@mail.gmail.com> <3530313B48D5704B86CF382E8866C7F9AE0F58E420@IRVEXCHCCR02.corp.ad.broadcom.com>
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Date: Mon, 14 Nov 2011 12:31:53 -0800
Message-ID: <CAA6KcBC0DXTaTHb-opd_HyTa91=XeuuHi-PFi+gqKxOurY9W1g@mail.gmail.com>
Subject: Re: [PATCH] usb: noted broken URL link in usb.c description
To: Michael Lewis <miclewis@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, it hasn't been updated since 2008, but it still used to get hit
periodically before I shutdown the server several months ago.

Let me see about moving the whopping 2 HTML files, one TXT file, and
one PNG to a different server within the organization... if it doesn't
happen in a few days, we should just take out all references to that
URL, not just mark it as a dead link.

Matt

On Mon, Nov 14, 2011 at 12:28 PM, Michael Lewis <miclewis@broadcom.com> wrote:
> Sure, that's fine. I didn't know if you were still actively maintaining it or not.
>
> Thanks,
> - Mike
>
>
> -----Original Message-----
> From: Matthew Dharm [mailto:mdharm-usb@one-eyed-alien.net]
> Sent: Monday, November 14, 2011 12:25 PM
> To: Michael Lewis
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] usb: noted broken URL link in usb.c description
>
> A fair point.  I should get around to fixing that.  Why don't we
> hold-off on the patch and let me work on this for a couple of days?
>
> Matt
>
> On Mon, Nov 14, 2011 at 12:14 PM, Michael Lewis <miclewis@broadcom.com> wrote:
>> From ca036284fdc2a6801fab566c2218307235518876 Mon Sep 17 00:00:00 2001
>> From: Michael Lewis <miclewis@broadcom.com>
>> Date: Mon, 14 Nov 2011 11:47:42 -0800
>> Subject: [PATCH] usb: noted broken URL link in usb.c description
>>
>>
>> Signed-off-by: Michael Lewis <miclewis@broadcom.com>
>> ---
>>  drivers/usb/storage/usb.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
>> index aa84b3d..33cf6ad 100644
>> --- a/drivers/usb/storage/usb.c
>> +++ b/drivers/usb/storage/usb.c
>> @@ -28,7 +28,8 @@
>>  * status of a command.
>>  *
>>  * Please see http://www.one-eyed-alien.net/~mdharm/linux-usb for more
>> - * information about this driver.
>> + * information about this driver. Note, URL link is dead and needs
>> + * to be fixed.
>>  *
>>  * This program is free software; you can redistribute it and/or modify it
>>  * under the terms of the GNU General Public License as published by the
>> --
>> 1.7.1
>>
>>
>
>
>
> --
> Matthew Dharm
> Maintainer, USB Mass Storage driver for Linux
>
>
>



-- 
Matthew Dharm
Maintainer, USB Mass Storage driver for Linux
