Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0KHOHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:07:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57460 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0KHOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:07:52 -0500
Message-ID: <20E08A7079E04279971AFD632B5A00A9@wipblrx0099946>
From: "Hemanth V" <hemanthv@ti.com>
To: "Jonathan Cameron" <jic23@cam.ac.uk>, "Dmitry Torokhov" <dtor@mail.ru>
Cc: "LKML" <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>,
        "Manuel Stahl" <manuel.stahl@iis.fraunhofer.de>,
        "Jean Delvare" <khali@linux-fr.org>, "Greg KH" <greg@kroah.com>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>, <drivers@analog.com>,
        <achew@nvidia.com>, "Donggeun Kim" <dg77.kim@samsung.com>
References: <4C98C7FE.4050305@cam.ac.uk> <03d301cb5bd4$152287d0$LocalHost@wipblrx0099946> <4C9C927B.1010500@cam.ac.uk> <4CA06714.8080008@cam.ac.uk> <4CA46126.7020104@cam.ac.uk>
Subject: Re: Sensor event related attribute naming.
Date: Mon, 8 Nov 2010 19:37:03 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5843
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Jonathan Cameron" <jic23@cam.ac.uk>
To: "Jonathan Cameron" <jic23@cam.ac.uk>
Sent: Thursday, September 30, 2010 3:36 PM
Subject: Re: Sensor event related attribute naming.


> Given the lack of further comment, I went ahead and implemented the above 
> naming
> scheme for IIO. As the above discussion with Hemanth shows, there are some 
> corner cases
> that will need futher thought in the future.
>

Jonathan, haven't seen many comments on this. Do u think the reason
might be that these interfaces are hidden behind a HAL layer like in android 
and
might not be a burning issue for many people.

Thanks
Hemanth


