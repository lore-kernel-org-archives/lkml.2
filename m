Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2A2Qdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 11:33:33 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58351 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030Ab2A2Qdc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 11:33:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120129043010.GA27141@kroah.com>
References: <CAFQ_mD6DThCcsvy5=A0sMVBn-1mhwyTeGsM8GpSS__5zDU6K-A@mail.gmail.com>
	<4F2411F4.6040403@mvista.com>
	<20120129043010.GA27141@kroah.com>
Date: Sun, 29 Jan 2012 17:33:30 +0100
Message-ID: <CAFQ_mD5CMThk-Yeoj6mZAYjHgZ_D6v=Yd7Egjrd0RRvQ-J8amQ@mail.gmail.com>
Subject: Re: [PATCH] qcserial: add support for Huawei Gobi 3000 devices
From: =?ISO-8859-1?Q?Jos=E9_Antonio_Matute?= <matutet@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Sergei,

As you're seeing, GMail web client isn't the correct tool for this job :(

Next time I'll try do it better.

Thank you!

2012/1/29 Greg KH <greg@kroah.com>:
> On Sat, Jan 28, 2012 at 07:19:16PM +0400, Sergei Shtylyov wrote:
>> Hello.
>>
>> On 28-01-2012 13:11, José Antonio Matute wrote:
>>
>> >From: Jose Antonio Matute<matutet@gmail.com>
>>
>>   Should be an empty line here, no?
>>
>> >Add USB IDs for Huawei Gobi 3000 devices (some of which are rebranded
>> >as Sony Vaio VPCSA modems).
>>
>> >Signed-off-by: Jose Antonio Matute<matutet@gmail.com>
>> >Cc: stable@vger.kernel.org
>> >---
>> >--- linux-3.3-rc1/drivers/usb/serial/qcserial.c.orig 2012-01-28
>> >09:43:01.088140483 +0100
>> >+++ linux-3.3-rc1/drivers/usb/serial/qcserial.c      2012-01-28
>> >09:46:37.908131967 +0100
>> >@@ -87,6 +87,7 @@ static const struct usb_device_id id_tab
>> >     {USB_DEVICE(0x05c6, 0x9204)},   /* Gobi 2000 QDL device */
>> >     {USB_DEVICE(0x05c6, 0x9205)},   /* Gobi 2000 Modem device */
>> >     {USB_DEVICE(0x1199, 0x9013)},   /* Sierra Wireless Gobi 3000 Modem
>> >device (MC8355) */
>>
>>    The patch is line wrapped; seems ealsy to fix tho...
>
> I will fix it by hand for this simple thing, don't worry, the patch is
> fine.
>
> greg k-h



-- 
Un saludo,
        José Antonio Matute
        Tf: 680 410 763
        matutet@gmail.com
        http://www.cmaj.es
