Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2AMG6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 01:58:33 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:55213 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2AMG6c (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 13 Jan 2012 01:58:32 -0500
Subject: Re: high speed cams are not working on usbip
From: joeyli <jlee@suse.com>
To: David Chang <dchang@suse.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org,
        nagarjun kommineni <nagarjunkommineni@gmail.com>
In-Reply-To: <CAKPZvrY_Bh95+bZX52yrM2+ODFm_U40i3E461xW-ho=Z-xPM4g@mail.gmail.com>
References: <CAKPZvrbFV5oR8tHJEYUzBhC7Z4pSaCXdG_3BGD0jK-6_A3nmiw@mail.gmail.com>
	 <1326192547.11926.5.camel@linux-s257.site>
	 <CAL-cBk011b4QbSRRuKxbZhNKxQQ-DkRHvq34Ua881h+AKXY_NQ@mail.gmail.com>
	 <CAKPZvrZdw_n_JRw=WvUXEwO6E8HtE=tgQo0G5MCERbwjOY+Fgw@mail.gmail.com>
	 <CAKPZvrY_Bh95+bZX52yrM2+ODFm_U40i3E461xW-ho=Z-xPM4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jan 2012 14:54:47 +0800
Message-ID: <1326437687.12400.45.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, 

Per your experience, what is the limit resolution for playing smoothly.
Do you think this is relate to the protocol of usbip?


Thanks
Joey Lee

於 三，2012-01-11 於 18:05 +0530，nagarjun kommineni 提到：
> 
> Hi,
> I tested it on 3.1.4
> 
> 2012/1/11 nagarjun kommineni <nagarjunkommineni@gmail.com>
>         hi,
>         these are the my test specifications.
>         
>         OS:            Scientific Linux 6.1 (default kernel 2.6.32)
>         Kernel:       3.1.4 (I have built it)
>         Web Cam:  Logitech Pro 9000
>         Test App:   Gstreamer
>         
>         To see the web cam output I have used the Gstreamer  with the
>         following command.
>         gst-launch v4l2src !
>         video/x-raw-yuv,width=160,height=120,framerate=15/1 !
>         ffmpegcolorspace ! autovideosink
>         
>         my cam supported resloutions are 160*120, 176*144, 320*240,
>         352*288, 640*480, 800*600, 960*720, 1600*1200.
>         
>         it works fine upto 320*240, beyond this it doesn't work.
>         
>         
>         2012/1/10 David Chang <dchang@suse.com>
>                 Hi Joey,
>                 
>                 2012/1/10 joeyli <jlee@suse.com>:
>                 > 於 二，2012-01-10 於 13:46 +0530，nagarjun kommineni
>                 提到：
>                 >> Hi,
>                 >>
>                 >> problem with usbip in drivers/staging/usbip
>                 >>
>                 >>  I have configured one pc as server and one as
>                 client, with this
>                 >> configuration high speed web cams are not working
>                 for higher
>                 >> resolutions.
>                 >>
>                 >
>                 > How "high" does this web's speed?
>                 >
>                 >> please have a look at this problem.
>                 >>
>                 >
>                 > David,
>                 > as I remember you test webcam in old kernel before?
>                 looks works fine.
>                 
>                 
>                 Yes, but I would suggest using lower resolution.
>                 
>                 Regards,
>                 David
>                 >
>                 >
>                 > Thanks
>                 > Joey Lee
>                 >
>                 >
>                 > --
>                 > To unsubscribe from this list: send the line
>                 "unsubscribe linux-kernel" in
>                 > the body of a message to majordomo@vger.kernel.org
>                 > More majordomo info at
>                  http://vger.kernel.org/majordomo-info.html
>                 > Please read the FAQ at  http://www.tux.org/lkml/
>         
>         
>         
>         
>         -- 
>         Regards,
>         Nagarjuna Kommineni.
>         
>         
> 
> 
> 
> -- 
> Regards,
> Nagarjuna Kommineni.
> 
> 


