Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab1GMTlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 15:41:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65180 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1GMTlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 15:41:17 -0400
MIME-Version: 1.0
In-Reply-To: <C3F4720C7083254FAB01F1C177F02212098A3A@exsvr1.accupoint.com.tw>
References: <1310362809-15273-1-git-send-email-ravishankarkm32@gmail.com>
	<CAN+gG=EUD+y1sUSvKT45zqQWXSUiEtxfMc21ip5um=D=psA9-w@mail.gmail.com>
	<C3F4720C7083254FAB01F1C177F02212098A3A@exsvr1.accupoint.com.tw>
Date: Wed, 13 Jul 2011 21:41:15 +0200
X-Google-Sender-Auth: cm5jFdBF0EeYVuCD6cYjDcZKzkU
Message-ID: <CAN+gG=FCB-8mOxEuhutGd0F3n1nQzoZcCpkNchq91Y4V7hdw9Q@mail.gmail.com>
Subject: Re: [PATCH] hid-multitouch driver: add one new hid multitouch
 device's VID/PID
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: "Ice.Chien" <ice.chien@accupoint.com.tw>
Cc: linux-kernel@vger.kernel.org, Jonson Wu <jonson.wu@accupoint.com.tw>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the patch looks good in terms of functionality. However there is still
a problem in the format introduced by your mail client.
As mentioned by Jiri, you'll find some answers in the file
Documentation/email-clients.txt at the root of the kernel tree (or
directly at http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob_plain;f=Documentation/email-clients.txt;hb=HEAD).
Basically copy/paste usually doesn't work.

If you still have problem in formatting the mail, you can also send me
the patch in private and I'll send it for you.

Cheers,
Benjamin

On Tue, Jul 12, 2011 at 04:46, Ice.Chien <ice.chien@accupoint.com.tw> wrote:
> Hi Benjamin,
>
> This is a patch to add one hid multitouch device's VID/PID in hid-core.c, hid-ids.h, hid-multitouch.c and Kconfig.
> Please review if I make the correct change
> Thanks.
>
> Signed-off-by: Ice Chien <ice.chien@accupoint.com.tw>
> ---
> diff    -u      ./linux-2.6.39.3/drivers/hid//hid-core.c        ./modified/drivers/hid//hid-core.c
> ---     ./linux-2.6.39.3/drivers/hid//hid-core.c        2011-07-09 14:16:06.000000000   +0800
> +++     ./modified/drivers/hid//hid-core.c      2011-07-11 13:36:07.784957908   +0800
> @@      -1482,6 +1482,7 @@
>        {       HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,    USB_DEVICE_ID_WALTOP_SLIM_TABLET_12_1_INCH)     },
>        {       HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,    USB_DEVICE_ID_WALTOP_MEDIA_TABLET_10_6_INCH)    },
>        {       HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,    USB_DEVICE_ID_WALTOP_MEDIA_TABLET_14_1_INCH)    },
> +       {       HID_USB_DEVICE(USB_VENDOR_ID_XAT,       USB_DEVICE_ID_XAT_CSR)  },
>        {       HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS,  0x0005) },
>        {       HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS,  0x0030) },
>        {       HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON,  USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL)  },
> Diff    -u      ./linux-2.6.39.3/drivers/hid//hid-ids.h ./modified/drivers/hid//hid-ids.h
> ---     ./linux-2.6.39.3/drivers/hid//hid-ids.h 2011-07-09 14:16:06.000000000   +0800
> +++     ./modified/drivers/hid//hid-ids.h       2011-07-11 13:36:05.969865971   +0800
> @@      -607,6  +607,9  @@
>  #define        USB_VENDOR_ID_WISEGROUP_LTD2    0x6677
>  #define        USB_DEVICE_ID_SMARTJOY_DUAL_PLUS        0x8802
>
> +#define        USB_VENDOR_ID_XAT       0x2505
> +#define        USB_DEVICE_ID_XAT_CSR   0x0220
> +
>  #define        USB_VENDOR_ID_YEALINK   0x6993
>  #define        USB_DEVICE_ID_YEALINK_P1K_P4K_B2K       0xb001
>
> Diff    -u      ./linux-2.6.39.3/drivers/hid//hid-multitouch.c  ./modified/drivers/hid//hid-multitouch.c
> ---     ./linux-2.6.39.3/drivers/hid//hid-multitouch.c  2011-07-09 14:16:06.000000000   +0800
> +++     ./modified/drivers/hid//hid-multitouch.c        2011-07-12 10:07:46.505165622   +0800
> @@      -487,6  +487,10 @@
>  }
>
>  Static const   struct  hid_device_id mt_devices[]      =       {
> +       /* XAT */
> +       {       .driver_data    =       MT_CLS_DEFAULT,
> +       HID_USB_DEVICE(USB_VENDOR_ID_XAT,
> +       USB_DEVICE_ID_XAT_CSR) },
>
>        /* Cypress panel */
>        {       .driver_data    =       MT_CLS_CYPRESS,
> Diff    -u      ./linux-2.6.39.3/drivers/hid//Kconfig   ./modified/drivers/hid//Kconfig
> ---     ./linux-2.6.39.3/drivers/hid//Kconfig   2011-07-09      14:16:06.000000000      +0800
> +++     ./modified/drivers/hid//Kconfig 2011-07-12      10:08:33.617597671      +0800
> @@      -327,6 +327,7   @@
>        - 'Sensing Win7-TwoFinger' panel by GeneralTouch
>        - eGalax dual-touch panels, including the
>        Joojoo and Wetab tablets
> +       - XAT optical touch panels
>
>        If unsure, say N.
>
> Common subdirectories: ./linux-2.6.39.3/drivers/hid//usbhid and ./modified/drivers/hid//usbhid
>
> -----Original Message-----
> From: benjamin.tissoires@gmail.com [mailto:benjamin.tissoires@gmail.com] On Behalf Of Benjamin Tissoires
> Sent: Monday, July 11, 2011 2:52 PM
> To: Ice.Chien
> Cc: linux-kernel@vger.kernel.org; Jonson Wu; linux-input; Jiri Kosina; Dmitry Torokhov; Henrik Rydberg; Stéphane Chatty
> Subject: Re: [PATCH] hid-multitouch driver: add one new hid multitouch device's VID/PID
>
> Hi,
>
> adding in CC the input list and the maintainers ;-)
>
> Though the patch is clean (except that you should replace spaces by
> tabs of 8 chars, I will mention it inlined in the patch), don't you
> want to also add your device to the hid-multitouch driver?
> If it's the case (we can still add it from the user space, but it will
> not work out of the box for everybody), please also add it to
> hid-multitouch and to the HID_MULTITOUCH section in the Kconfig  file.
>
> Thanks for the work.
>
> On Mon, Jul 11, 2011 at 07:59, Ice.Chien <ice.chien@accupoint.com.tw> wrote:
>> This is a patch to add one hid multitouch device's VID/PID in hid-ids.h
>> and hid-core.c
>>
>> Signed-off-by: Ice Chien <ice.chien@accupoint.com.tw>
>> ---
>> diff -u ./linux-2.6.39.3/drivers/hid//hid-core.c
>> ./modified/drivers/hid//hid-core.c
>> --- ./linux-2.6.39.3/drivers/hid//hid-core.c    2011-07-09
>> 14:16:06.000000000 +0800
>> +++ ./modified/drivers/hid//hid-core.c  2011-07-11 13:36:07.784957908
>> +0800
>> @@ -1482,6 +1482,7 @@
>>        { HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,
>> USB_DEVICE_ID_WALTOP_SLIM_TABLET_12_1_INCH) },
>>        { HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,
>> USB_DEVICE_ID_WALTOP_MEDIA_TABLET_10_6_INCH) },
>>        { HID_USB_DEVICE(USB_VENDOR_ID_WALTOP,
>> USB_DEVICE_ID_WALTOP_MEDIA_TABLET_14_1_INCH) },
>> +       { HID_USB_DEVICE(USB_VENDOR_ID_XAT, USB_DEVICE_ID_XAT_CSR) },
>
> replace leading spaces by tabs here
>
>>        { HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
>>        { HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
>>        { HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON,
>> USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
>> diff -u ./linux-2.6.39.3/drivers/hid//hid-ids.h
>> ./modified/drivers/hid//hid-ids.h
>> --- ./linux-2.6.39.3/drivers/hid//hid-ids.h     2011-07-09
>> 14:16:06.000000000 +0800
>> +++ ./modified/drivers/hid//hid-ids.h   2011-07-11 13:36:05.969865971
>> +0800
>> @@ -607,6 +607,9 @@
>>  #define USB_VENDOR_ID_WISEGROUP_LTD2   0x6677
>>  #define USB_DEVICE_ID_SMARTJOY_DUAL_PLUS 0x8802
>>
>> +#define USB_VENDOR_ID_XAT               0x2505
>
> replace spaces by tabs
>
>> +#define USB_DEVICE_ID_XAT_CSR           0x0220
>
> again ;-)
>
> Cheers,
> Benjamin
>
>> +
>>  #define USB_VENDOR_ID_YEALINK          0x6993
>>  #define USB_DEVICE_ID_YEALINK_P1K_P4K_B2K      0xb001
>>
>> Common subdirectories: ./linux-2.6.39.3/drivers/hid//usbhid and
>> ./modified/drivers/hid//usbhid
>>
>
