Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2DWLSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:18:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64655 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2DWLSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:18:39 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20120420162710.GA6416@kroah.com>
References: <20120420033209.GA17930@kroah.com>
	<1334898987-7800-1-git-send-email-myungjoo.ham@samsung.com>
	<20120420162710.GA6416@kroah.com>
Date: Mon, 23 Apr 2012 20:18:38 +0900
X-Google-Sender-Auth: qqoOj5fhLcIVm1j-AH14XziBlr4
Message-ID: <CAJ0PZbQu6NCo=nYWr_D3yMF5ypaz_SDr6mFWxyN04VO13VmW=Q@mail.gmail.com>
Subject: Re: [PATCH v8 resend 0/6] Introduce External Connector Class (extcon)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>, cw00.choi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 1:27 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Apr 20, 2012 at 02:16:21PM +0900, MyungJoo Ham wrote:
>> In order to address such issues, Android kernel's "Switch" class seems to
>> be a good basis and we have implemented "Multistate Switch Class" based on
>> it. The "Switch" class code of Android kernel is GPL as well.
>
> Ok, I've applied these patches to my driver-core tree, thanks so much
> for working to clean this up and get it merged, very nice job.
>
> Now, does this mean I can delete the drivers/staging/android/switch/
> directory from the tree as well?

Yes, I think we can now delete switch directory because switch_gpio.c
was the only driver in the directory and it also appears with extcon.
In fact, there was an RFC patch to do so w/ v7 patchset.

I'll send the patch as a reply to this message.


Cheers!
MyungJoo.

>
> If so, I will be glad to do that.
>
> If not, what is left to do in order for it to be removed?
>
> thanks,
>
> greg k-h




-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
