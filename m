Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab2JDIP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:15:27 -0400
Received: from wren.arvixe.com ([50.97.138.99]:56750 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab2JDIPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:15:22 -0400
Message-ID: <3b6f1beb0a048e1d02a7f684447c46b8.squirrel@webmail.firszt.eu>
In-Reply-To: <20121004072528.GD14217@core.coreip.homeip.net>
References: <1347219438-2598-1-git-send-email-przemo@firszt.eu>
    <20121004072528.GD14217@core.coreip.homeip.net>
Date: Thu, 4 Oct 2012 09:15:19 +0100
Subject: Re: [PATCH] USB: input: wacom_sys.c: format OLED image in kernel
From: "Przemo Firszt" <przemo@firszt.eu>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Przemo Firszt" <przemo@firszt.eu>, rob@landley.net, pinglinux@gmail.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Reply-To: przemo@firszt.eu
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-2
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dnia 4 Pa¼dziernika 2012, 8:25 am, Cz, Dmitry Torokhov napisa³(a):
> Hi Przemo,
Hi Dmitry,
>
> On Sun, Sep 09, 2012 at 03:37:18PM -0400, Przemo Firszt wrote:
>> This patch adds a new way of handling Wacom Intuos4 family OLEDs.
>> Previously the images had to be 'scrambled' by userland application. Now
>> the 'scrambling' is done in the kernel module, so user space can send
>> simple 64x32 pixels 4-bit grayscale (2 pixels per byte) 0,0 in top left
>> corner
>> images straight to a wacom OLED sysfs entry. An example:
>>
>> dd bs=1024 if=image_file \
>> of=/sys/bus/usb/drivers/wacom/[DevNo]/wacom_led/button[No]_formattedimg
>> \
>> count=1
>>
>> This patch greatly simplifies user space preparation of the image.
>> The raw image sysfs enties are still present to avoid breaking API.
>
> I do not not believe that we should add code to the kernel for tasks that
> can be just as easily performed in userspace.
>
> Thanks!
>
> --
> Dmitry
>
OK, thanks for the explanation!

-- 
Regards,
Przemo Firszt

