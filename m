Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab2INO3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:29:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33218 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab2INO3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:29:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120914120423.GD4152@breakpoint.cc>
References: <1347616403-3413-1-git-send-email-navinp@cdac.in>
	<50531832.3050902@mvista.com>
	<20120914120423.GD4152@breakpoint.cc>
Date: Fri, 14 Sep 2012 19:59:06 +0530
X-Google-Sender-Auth: QLtLKLozjO_N2FU2teY-5a6WRaQ
Message-ID: <CAPV97ye-nW3oRtbDeVTAKaeTcHK2iyr8AuzEWmizRsD83fba7g@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: stub_dev: Fixed oops during removal of usbip_host
From: navin patidar <navinp@cdac.in>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Cc: gregkh@linuxfoundation.org, mfm@muteddisk.com, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I have sent this patch again with corrections.
thank for reviewing the patch.

--navin-patidar

On 9/14/12, Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:
> On Fri, Sep 14, 2012 at 03:42:42PM +0400, Sergei Shtylyov wrote:
>> >diff --git a/drivers/staging/usbip/stub_dev.c
>> > b/drivers/staging/usbip/stub_dev.c
>> >index 92ced35..f584af8 100644
>> >--- a/drivers/staging/usbip/stub_dev.c
>> >+++ b/drivers/staging/usbip/stub_dev.c
>> >@@ -233,6 +230,13 @@ static void stub_device_reset(struct usbip_device
>> > *ud)
>> >
>> >  	dev_dbg(&udev->dev, "device reset");
>> >
>> >+	/*reset tcp socket*/
>>
>>    Add spaces after /* and before */, please.
>>
>> >+	ud->tcp_socket = NULL;
>> >+
>> >+	/*reset kernel thread pointers */
>>
>>    Here too.
>
> I'm not sure it is required to comment the obvious things.
>
>> WBR, Sergei
>
> Sebastian
>
