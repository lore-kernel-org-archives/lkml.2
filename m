Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab2CJGcF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 01:32:05 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57839 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2CJGb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 01:31:59 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1203091329030.18356@pobox.suse.cz>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
	<1331053026-21272-2-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1203091329030.18356@pobox.suse.cz>
Date: Sat, 10 Mar 2012 07:31:57 +0100
Message-ID: <CAN+gG=F0w88T-iDxVJNEjgyud8FwC5vTGT8+2KTva8FXgFjTog@mail.gmail.com>
Subject: Re: [PATCH 1/5] HID: multitouch: add support for eGalax 0x722a
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 13:29, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 6 Mar 2012, benjamin.tissoires wrote:
>
>> From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>>  drivers/hid/hid-ids.h        |    1 +
>>  drivers/hid/hid-multitouch.c |    3 +++
>>  2 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>> index 6656516..e1fada2 100644
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@ -240,6 +240,7 @@
>>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7207    0x7207
>>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_720C    0x720c
>>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7224    0x7224
>> +#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_722A    0x722A
>>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_725E    0x725e
>>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7262    0x7262
>>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B    0x726b
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 0eda37f..019de83 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -797,6 +797,9 @@ static const struct hid_device_id mt_devices[] = {
>>       { .driver_data = MT_CLS_EGALAX_SERIAL,
>>               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>>                       USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7224) },
>> +     { .driver_data = MT_CLS_EGALAX_SERIAL,
>> +             HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>> +                     USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_722A) },
>>       { .driver_data = MT_CLS_EGALAX,
>>               HID_USB_DEVICE(USB_VENDOR_ID_DWAV,
>>                       USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_726B) },
>
> Applied.
>

Thanks Jiri.
How about patches 2,3 and 5?
Patch 2 is waited for LG users since a long time now (though it gives warnings).
Patch 3 can be included without patch 4: just loading hid-multitouch
makes the device working. And even if it's a little "hackish", it
won't hurt any other hid devices.
Patch 5 will introduce more robustness for the default class, but
requires patch 3.

Cheers,
Benjamin

> --
> Jiri Kosina
> SUSE Labs
