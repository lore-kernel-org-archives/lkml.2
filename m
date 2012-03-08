Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2CHPgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:36:24 -0500
Received: from ftp.meprolight.com ([194.90.149.17]:38762 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756738Ab2CHPgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:36:22 -0500
From: Alex Gershgorin <alexg@meprolight.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 8 Mar 2012 17:36:05 +0200
Subject: RE: I.MX35 PDK
Thread-Topic: I.MX35 PDK
Thread-Index: Acz9HkV7bT83WPdPRTWZq0S4mS8XBwAAuFcUAAemTME=
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8918@MEP-EXCH.meprolight.com>
References: <CAOMZO5DnP7+zupy9vwBPS0+2XtKM1+nLbwCqBzuCqEG5OWbZRQ@mail.gmail.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD666A28@MEP-EXCH.meprolight.com>,<CAOMZO5Amo0XFf+TV7PprCL079C5Y0qKmo+k-FfShU7k4SG7W6Q@mail.gmail.com>,<4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8913@MEP-EXCH.meprolight.com>
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8913@MEP-EXCH.meprolight.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>On my mx31pdk I get the same dmaengine errors and the ov2640 does work fine.
>I think you can go ahead and try to use the camera on the mx35pdk now.
>You can try:

>gst-launch -v v4l2src device=/dev/video0 !
>video/x-raw-yuv,width=320,height=240,framerate=25/1 ! ffmpegcolorspace
>! fbdevsink

<<Thank Fabio I'll try to check it.

I tried to test it, everything is fine,  just do not see the video on display.
Here can see messages:

Setting pipeline to PAUSED ...mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
/GstPipeline:pipeline0/GstV4l2Src:v4l2src0.GstPad:src: caps = video/x-raw-yuv, format=(fourcc)UYVY, framerate=(fraction)25/1, width=(int)320, height=(int)240, interlaced=(boolean)false
Pipeline is live and does not need PREROLL ...
WARNING: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could not get parameters on device '/dev/video0'
Additional debug info:
v4l2src_calls.c(240): gst_v4l2src_set_capture (): /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
system error: Invalid argument
Setting pipeline to PLAYING ...
New clock: GstSystemClock

It works well :-) 
gst-launch videotestsrc ! fbdevsink

Regards
Alex Gershgorin
