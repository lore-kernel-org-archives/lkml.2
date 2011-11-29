Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1K2MoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:44:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52648 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab1K2MoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:44:12 -0500
Message-ID: <4ED4D398.3070506@gmail.com>
Date: Tue, 29 Nov 2011 14:44:08 +0200
From: Rares Aioanei <krnl.list@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Tarkan Erimer <tarkan.erimer@f-secure.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] uvcvideo is broken on Linux-3.2-rc3
References: <4ED4BD22.3070003@f-secure.com>
In-Reply-To: <4ED4BD22.3070003@f-secure.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 01:08 PM, Tarkan Erimer wrote:
> Hi,
>
> When I initiate any webcam software like Cheese, Kamoso, skype etc. 
> I'm having the below message at dmesg :
>
> [ 1171.856931] uvcvideo: Failed to submit URB 0 (-28).
> [ 1191.728944] uvcvideo: Failed to submit URB 0 (-28).
> [ 1191.728959] uvcvideo 1-1.5:1.1: resume error -28
> [ 1192.028821] uvcvideo: Failed to query (GET_DEF) UVC control 3 on 
> unit 2: -110 (exp. 2).
> [ 1192.106345] uvcvideo: Failed to query (GET_DEF) UVC control 3 on 
> unit 2: -32 (exp. 2).
> [ 1605.542802] uvcvideo: Failed to query (130) UVC probe control : -32 
> (exp. 26).
> [ 1605.549179] uvcvideo: Failed to query (130) UVC probe control : -32 
> (exp. 26).
> [ 1605.555584] uvcvideo: Failed to query (130) UVC probe control : -32 
> (exp. 26).
> [ 1605.562031] uvcvideo: Failed to query (130) UVC probe control : -32 
> (exp. 26).
> [ 1605.568382] uvcvideo: Failed to query (130) UVC probe control : -32 
> (exp. 26).
> [ 1605.575002] uvcvideo: Failed to query (130) UVC probe control : -32 
> (exp. 26).
> [ 1605.581982] uvcvideo: Failed to query (130) UVC probe control : -32 
> (exp. 26).
> [ 1605.588635] uvcvideo: Failed to query (130) UVC probe control : -32 
> (exp. 26).
> [ 1605.595000] uvcvideo: Failed to query (130) UVC probe control : -32 
> (exp. 26).
> [ 1605.601328] uvcvideo: Failed to query (130) UVC probe control : -32 
> (exp. 26).
> [ 1605.607702] uvcvideo: Failed to query (130) UVC probe control : -32 
> (exp. 26).
>
>
>
> Also, below is the output of "v4l-info" :
>
>
> linux-gpq3:~ # v4l-info
>
> ### v4l2 device info [/dev/video0] ###
> general info
>     VIDIOC_QUERYCAP
>         driver                  : "uvcvideo"
>         card                    : "Laptop_Integrated_Webcam_HD"
>         bus_info                : "usb-0000:00:1a.0-1.5"
>         version                 : 3.2.0
>         capabilities            : 0x4000001 [VIDEO_CAPTURE,STREAMING]
>
> standards
>
> inputs
>     VIDIOC_ENUMINPUT(0)
>         index                   : 0
>         name                    : "Camera 1"
>         type                    : CAMERA
>         audioset                : 0
>         tuner                   : 0
>         std                     : 0x0 []
>         status                  : 0x0 []
>
> video capture
>     VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
>         index                   : 0
>         type                    : VIDEO_CAPTURE
>         flags                   : 0
>         description             : "YUV 4:2:2 (YUYV)"
>         pixelformat             : 0x56595559 [YUYV]
>     VIDIOC_ENUM_FMT(1,VIDEO_CAPTURE)
>         index                   : 1
>         type                    : VIDEO_CAPTURE
>         flags                   : 1
>         description             : "MJPEG"
>         pixelformat             : 0x47504a4d [MJPG]
>     VIDIOC_G_FMT(VIDEO_CAPTURE)
>         type                    : VIDEO_CAPTURE
>         fmt.pix.width           : 640
>         fmt.pix.height          : 480
>         fmt.pix.pixelformat     : 0x56595559 [YUYV]
>         fmt.pix.field           : NONE
>         fmt.pix.bytesperline    : 1280
>         fmt.pix.sizeimage       : 614400
>         fmt.pix.colorspace      : SRGB
>         fmt.pix.priv            : 0
>
> controls
>     VIDIOC_QUERYCTRL(BASE+0)
>         id                      : 9963776
>         type                    : INTEGER
>         name                    : "Brightness"
>         minimum                 : -64
>         maximum                 : 64
>         step                    : 1
>         default_value           : 0
>         flags                   : 0
>     VIDIOC_QUERYCTRL(BASE+1)
>         id                      : 9963777
>         type                    : INTEGER
>         name                    : "Contrast"
>         minimum                 : 0
>         maximum                 : 95
>         step                    : 1
>         default_value           : 0
>         flags                   : 0
>     VIDIOC_QUERYCTRL(BASE+2)
>         id                      : 9963778
>         type                    : INTEGER
>         name                    : "Saturation"
>         minimum                 : 0
>         maximum                 : 100
>         step                    : 1
>         default_value           : 64
>         flags                   : 0
>     VIDIOC_QUERYCTRL(BASE+3)
>         id                      : 9963779
>         type                    : INTEGER
>         name                    : "Hue"
>         minimum                 : -2000
>         maximum                 : 2000
>         step                    : 1
>         default_value           : 0
>         flags                   : 0
>     VIDIOC_QUERYCTRL(BASE+12)
>         id                      : 9963788
>         type                    : BOOLEAN
>         name                    : "White Balance Temperature, Auto"
>         minimum                 : 0
>         maximum                 : 1
>         step                    : 1
>         default_value           : 1
>         flags                   : 0
>     VIDIOC_QUERYCTRL(BASE+16)
>         id                      : 9963792
>         type                    : INTEGER
>         name                    : "Gamma"
>         minimum                 : 100
>         maximum                 : 300
>         step                    : 1
>         default_value           : 100
>         flags                   : 0
>     VIDIOC_QUERYCTRL(BASE+24)
>         id                      : 9963800
>         type                    : MENU
>         name                    : "Power Line Frequency"
>         minimum                 : 0
>         maximum                 : 2
>         step                    : 1
>         default_value           : 0
>         flags                   : 0
>     VIDIOC_QUERYCTRL(BASE+26)
>         id                      : 9963802
>         type                    : INTEGER
>         name                    : "White Balance Temperature"
>         minimum                 : 2800
>         maximum                 : 6500
>         step                    : 1
>         default_value           : 4600
>         flags                   : 0
>     VIDIOC_QUERYCTRL(BASE+27)
>         id                      : 9963803
>         type                    : INTEGER
>         name                    : "Sharpness"
>         minimum                 : 1
>         maximum                 : 7
>         step                    : 1
>         default_value           : 2
>         flags                   : 0
>     VIDIOC_QUERYCTRL(BASE+28)
>         id                      : 9963804
>         type                    : INTEGER
>         name                    : "Backlight Compensation"
>         minimum                 : 0
>         maximum                 : 3
>         step                    : 1
>         default_value           : 3
>         flags                   : 0
>
>
> PS : The same hardware works perfectly with pre <= Linux-3.1
I can confirm this with a Microsoft LifeCam webcam and kernel 
3.2.0-rc3-00023-g401d006.

-- 
--
Rares Aioanei

