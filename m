Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab0KCTIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 15:08:02 -0400
Received: from mognix.dark-green.com ([88.116.226.179]:55685 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab0KCTH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:07:59 -0400
Message-ID: <4CD1B30C.6010904@dark-green.com>
Date: Wed, 03 Nov 2010 20:07:56 +0100
From: gimli <gimli@dark-green.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; de; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
CC: Marcel Holtmann <marcel@holtmann.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] MacBookAir3,1(3,2) btusb support
References: <9e7738c0461aa509dd55fe470df3855e@mognix.dark-green.com> <20101102152454.GC11778@core.coreip.homeip.net> <1288712282.3322.181.camel@aeonflux> <20101103182159.GA17943@vigoh>
In-Reply-To: <20101103182159.GA17943@vigoh>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in what form i should provide it ?

cu

Edgar (gimli) Hucek

Am 03.11.10 19:21, schrieb Gustavo F. Padovan:
> Hi Edgar,
>
> * Marcel Holtmann<marcel@holtmann.org>  [2010-11-02 16:38:02 +0100]:
>
>> Hi Dmitry,
>>
>>> Not sure of you guys monitor LKML...
>>
>> not on a regular basis.
>>
>>>> This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the btusb
>>>> driver.
>>>>
>>>> Signed-off-by: Edgar (gimli) Hucek<gimli@dark-green.com>
>
> Please also provide the output of usb-devices for this hardware in
> commit message when resubmitting the patch.
>
>>>
>>>> --- a/drivers/bluetooth/btusb.c	2010-10-30 21:08:45.170492002 +0200
>>>> +++ b/drivers/bluetooth/btusb.c	2010-10-30 21:18:11.820492000 +0200
>>>> @@ -62,6 +62,9 @@
>>>>   	/* Apple iMac11,1 */
>>>>   	{ USB_DEVICE(0x05ac, 0x8215) },
>>>>
>>>> +	/* Apple MacBookAir3,1, MacBookAir3,2 */
>>>> +	{ USB_DEVICE(0x05ac, 0x821b) },
>>>> +
>>>>   	/* AVM BlueFRITZ! USB v2.0 */
>>>>   	{ USB_DEVICE(0x057c, 0x3800) },
>>
>> patch looks fine to me, but it should be send to linux-bluetooth mailing
>> list.
>>
>> Acked-by: Marcel Holtmann<marcel@holtmann.org>
>

