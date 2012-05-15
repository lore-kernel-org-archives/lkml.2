Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966794Ab2EOUus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:50:48 -0400
Received: from smarthost01.digicable.hu ([94.21.128.6]:52524 "EHLO
	smarthost01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab2EOUuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:50:46 -0400
X-Greylist: delayed 2356 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2012 16:50:46 EDT
Message-ID: <4FB2B858.6000001@freemail.hu>
Date: Tue, 15 May 2012 22:11:04 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jozsef Marton <jmarton@users.sourceforge.net>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Rob Landley <rob@landley.net>, Jean-Francois Moine <moinejf@free.fr>,
        linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] media: add support to gspca/pac7302.c for 093a:2627 (Genius
 FaceCam 300)
References: <4FB27ED0.40906@users.sourceforge.net>
In-Reply-To: <4FB27ED0.40906@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 84.236.6.106
X-Original: 92.249.128.189
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Márton Németh <nm127@freemail.hu>

Jozsef Marton wrote:
> From: Jozsef Marton <jmarton@users.sourceforge.net>
> 
> gspca_pac7302 module supports the webcam with usb id: 093a:2627.
> It is a Genius FaceCam 300.
> The module does not need any changes but listing the usb id along with a vertical flip flag.
> The included patch adds this to the module source.
> 
> Signed-off-by: Jozsef Marton <jmarton@users.sourceforge.net>
> ---
> diff -uprN -X dontdiff linux-3.4-rc7-vanilla/Documentation/video4linux/gspca.txt linux-3.4-rc7/Documentation/video4linux/gspca.txt
> --- linux-3.4-rc7-vanilla/Documentation/video4linux/gspca.txt	2012-05-13 03:37:47.000000000 +0200
> +++ linux-3.4-rc7/Documentation/video4linux/gspca.txt	2012-05-15 16:56:55.603514846 +0200
> @@ -276,6 +276,7 @@ pac7302		093a:2622	Genius Eye 312
>  pac7302		093a:2624	PAC7302
>  pac7302		093a:2625	Genius iSlim 310
>  pac7302		093a:2626	Labtec 2200
> +pac7302		093a:2627	Genius FaceCam 300
>  pac7302		093a:2628	Genius iLook 300
>  pac7302		093a:2629	Genious iSlim 300
>  pac7302		093a:262a	Webcam 300k
> diff -uprN -X dontdiff linux-3.4-rc7-vanilla/drivers/media/video/gspca/pac7302.c linux-3.4-rc7/drivers/media/video/gspca/pac7302.c
> --- linux-3.4-rc7-vanilla/drivers/media/video/gspca/pac7302.c	2012-05-13 03:37:47.000000000 +0200
> +++ linux-3.4-rc7/drivers/media/video/gspca/pac7302.c	2012-05-15 15:15:03.355624405 +0200
> @@ -940,6 +940,7 @@ static const struct usb_device_id device
>  	{USB_DEVICE(0x093a, 0x2624), .driver_info = FL_VFLIP},
>  	{USB_DEVICE(0x093a, 0x2625)},
>  	{USB_DEVICE(0x093a, 0x2626)},
> +	{USB_DEVICE(0x093a, 0x2627), .driver_info = FL_VFLIP},
>  	{USB_DEVICE(0x093a, 0x2628)},
>  	{USB_DEVICE(0x093a, 0x2629), .driver_info = FL_VFLIP},
>  	{USB_DEVICE(0x093a, 0x262a)},
> 
> 

