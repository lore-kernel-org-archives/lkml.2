Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0IXKfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 06:35:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48165 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab0IXKfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 06:35:45 -0400
Message-ID: <03d301cb5bd4$152287d0$LocalHost@wipblrx0099946>
From: "Hemanth V" <hemanthv@ti.com>
To: "Jonathan Cameron" <jic23@cam.ac.uk>,
        "LKML" <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, "Dmitry Torokhov" <dtor@mail.ru>,
        "Manuel Stahl" <manuel.stahl@iis.fraunhofer.de>,
        "Jean Delvare" <khali@linux-fr.org>, "Greg KH" <greg@kroah.com>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>, <drivers@analog.com>,
        <achew@nvidia.com>, "Donggeun Kim" <dg77.kim@samsung.com>
References: <4C98C7FE.4050305@cam.ac.uk>
Subject: Re: Sensor event related attribute naming.
Date: Fri, 24 Sep 2010 16:04:25 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Jonathan Cameron" <jic23@cam.ac.uk>
<snip>
> 
> We have had naming conventions in IIO for a while but they have not
> yet been terribly satisfactory. Our latest suggestion, which I'm
> finally happy is general enough whilst remaining clear to be found
> in  http://marc.info/?l=linux-iio&m=128394796116223&w=2
> 
> Manuel Stahl pointed out that the following summary covers what was
> proposed in a clearer fashion.
> 
> <channel>_<limit>_<dir>_<attr>, where
> <channel>: name of the channel, i.e. accel_x0
> <limit>:   thresh, mag, roc
> <dir>:     rising, falling
> <attr>:    en, value, period, mean_period
> 

Jonathan, I am trying to understand howto apply this to cma3000. I
have few parameters like below. Would you be able to suggest how
the sysfs entries should look like for the below parameters or are these
still to be defined.

grange:  2000, 8000 mg 
sampling frequency  : 40, 100, 400 Hz
Modes : Motion detect, Measurement, Free fall

Thanks
Hemanth
