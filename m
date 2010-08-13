Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268Ab0HMMrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 08:47:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58446 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934206Ab0HMMrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 08:47:17 -0400
Message-ID: <0ebd01cb3ae5$a0dcfc70$LocalHost@wipblrx0099946>
From: "Hemanth V" <hemanthv@ti.com>
To: "Jonathan Cameron" <jic23@cam.ac.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com> <4BF6753B.60201@cam.ac.uk>
Subject: Re: [RFC] [PATCH V2 1/2] input: CMA3000 Accelerometer driver
Date: Fri, 13 Aug 2010 18:17:00 +0530
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
To: "Hemanth V" <hemanthv@ti.com>
Cc: <linux-input@vger.kernel.org>; <linux-kernel@vger.kernel.org>; 
<linux-omap@vger.kernel.org>
Sent: Friday, May 21, 2010 5:27 PM
Subject: Re: [RFC] [PATCH V2 1/2] input: CMA3000 Accelerometer driver


> On 05/21/10 07:52, Hemanth V wrote:
>> From: Hemanth V <hemanthv@ti.com>
>> Date: Thu, 20 May 2010 20:18:17 +0530
>> Subject: [PATCH] input: CMA3000 Accelerometer Driver
>>
>> This patch adds support for CMA3000 Tri-axis accelerometer, which
>> supports Motion detect, Measurement and Free fall modes.
>> CMA3000 supports both I2C/SPI bus for communication, currently the
>> driver supports I2C based communication.
>>
>> Driver reports acceleration data through input subsystem and supports
>> sysfs for configuration changes.
>>
>> This is V2 of patch, which fixes open source review comments
>>
>
> Hi,
>
> The driver is nice and clean.
>
> Still leaving aside the long argued question of whether this should be
> in input.  If you care for my views on that there are plenty or other
> threads! There are a few things I'd still like to suggest:
>

Jonathan, Andrew

Is there any way forward for this patch, I am unable to induce any response
from the input maintainer

Thanks
Hemanth 

