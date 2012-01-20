Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab2ATEkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 23:40:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62854 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab2ATEkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 23:40:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAKPZvrZwvHRaWnvBxQyXiHTds+N7aUiWStdHgrDtLXPrSQRjrA@mail.gmail.com>
References: <CAKPZvrbFV5oR8tHJEYUzBhC7Z4pSaCXdG_3BGD0jK-6_A3nmiw@mail.gmail.com>
	<1326192547.11926.5.camel@linux-s257.site>
	<CAL-cBk011b4QbSRRuKxbZhNKxQQ-DkRHvq34Ua881h+AKXY_NQ@mail.gmail.com>
	<CAKPZvrZdw_n_JRw=WvUXEwO6E8HtE=tgQo0G5MCERbwjOY+Fgw@mail.gmail.com>
	<CAL-cBk1J-LWCHQxzqVuj1x7B2CxN-8+bBoNTBPCG_8SntHkQOg@mail.gmail.com>
	<CAKPZvrZwvHRaWnvBxQyXiHTds+N7aUiWStdHgrDtLXPrSQRjrA@mail.gmail.com>
Date: Fri, 20 Jan 2012 10:10:30 +0530
Message-ID: <CAKPZvrbrOze=DTsLQBEORj7+fmXHSxq477xnvLR6zKtTbEKiTg@mail.gmail.com>
Subject: Re: high speed cams are not working on usbip
From: nagarjun kommineni <nagarjunkommineni@gmail.com>
To: David Chang <dchang@suse.com>
Cc: joeyli <jlee@suse.com>, linux-kernel@vger.kernel.org, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think we need to increase the depth of video buffers in UVC subsystem.


On 1/16/12, nagarjun kommineni <nagarjunkommineni@gmail.com> wrote:
> Hi,
>
> Both server and client are working at 100Mbps.
>
> On 1/16/12, David Chang <dchang@suse.com> wrote:
>> Hi,
>>
>> 在 2012年1月11日下午3:47，nagarjun kommineni <nagarjunkommineni@gmail.com> 寫道：
>>> hi,
>>> these are the my test specifications.
>>>
>>> OS:            Scientific Linux 6.1 (default kernel 2.6.32)
>>> Kernel:       3.1.4 (I have built it)
>>> Web Cam:  Logitech Pro 9000
>>> Test App:   Gstreamer
>>>
>>> To see the web cam output I have used the Gstreamer  with the following
>>> command.
>>> gst-launch v4l2src ! video/x-raw-yuv,width=160,height=120,framerate=15/1
>>> !
>>> ffmpegcolorspace ! autovideosink
>>>
>>> my cam supported resloutions are 160*120, 176*144, 320*240, 352*288,
>>> 640*480, 800*600, 960*720, 1600*1200.
>>>
>>> it works fine upto 320*240, beyond this it doesn't work.
>>
>> What's the speed of server and client network interface?
>>
>> David
>>>
>>>
>>> 2012/1/10 David Chang <dchang@suse.com>
>>>>
>>>> Hi Joey,
>>>>
>>>> 2012/1/10 joeyli <jlee@suse.com>:
>>>> > 於 二，2012-01-10 於 13:46 +0530，nagarjun kommineni 提到：
>>>> >> Hi,
>>>> >>
>>>> >> problem with usbip in drivers/staging/usbip
>>>> >>
>>>> >>  I have configured one pc as server and one as client, with this
>>>> >> configuration high speed web cams are not working for higher
>>>> >> resolutions.
>>>> >>
>>>> >
>>>> > How "high" does this web's speed?
>>>> >
>>>> >> please have a look at this problem.
>>>> >>
>>>> >
>>>> > David,
>>>> > as I remember you test webcam in old kernel before? looks works fine.
>>>>
>>>> Yes, but I would suggest using lower resolution.
>>>>
>>>> Regards,
>>>> David
>>>> >
>>>> >
>>>> > Thanks
>>>> > Joey Lee
>>>> >
>>>> >
>>>> > --
>>>> > To unsubscribe from this list: send the line "unsubscribe
>>>> > linux-kernel"
>>>> > in
>>>> > the body of a message to majordomo@vger.kernel.org
>>>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> > Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>>
>>>
>>> --
>>> Regards,
>>> Nagarjuna Kommineni.
>>>
>>>
>>
>
>
> --
> Regards,
> Nagarjuna Kommineni.
>


-- 
Regards,
Nagarjuna Kommineni.
