Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab0KOGlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:41:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41307 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab0KOGlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:41:23 -0500
Message-ID: <6100C6C94F5440C290CEC343F20F503F@wipblrx0099946>
From: "Hemanth V" <hemanthv@ti.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Jonathan Cameron" <jic23@cam.ac.uk>,
        "LKML" <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>,
        "Manuel Stahl" <manuel.stahl@iis.fraunhofer.de>,
        "Jean Delvare" <khali@linux-fr.org>, "Greg KH" <greg@kroah.com>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>, <drivers@analog.com>,
        <achew@nvidia.com>, "Donggeun Kim" <dg77.kim@samsung.com>
References: <7BC12C510D794F198DFA5A5C104CD7B6@wipblrx0099946> <20101112173227.GB1224@core.coreip.homeip.net>
Subject: Re: Sensor event related attribute naming.
Date: Mon, 15 Nov 2010 12:10:34 +0530
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
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Sent: Friday, November 12, 2010 11:02 PM
Subject: Re: Sensor event related attribute naming.


> On Fri, Nov 12, 2010 at 03:34:36PM +0530, Hemanth V wrote:
>> ----- Original Message ----- From: "Hemanth V" <hemanthv@ti.com>
>> To: "Jonathan Cameron" <jic23@cam.ac.uk>; "Dmitry Torokhov" 
>> <dtor@mail.ru>
>>
>>
>> >----- Original Message ----- From: "Jonathan Cameron"
>> ><jic23@cam.ac.uk>
>> >To: "Jonathan Cameron" <jic23@cam.ac.uk>
>> >Sent: Thursday, September 30, 2010 3:36 PM
>> >Subject: Re: Sensor event related attribute naming.
>> >
>> >
>> >>Given the lack of further comment, I went ahead and implemented
>> >>the above naming
>> >>scheme for IIO. As the above discussion with Hemanth shows,
>> >>there are some corner cases
>> >>that will need futher thought in the future.
>> >>
>> >
>> >Jonathan, haven't seen many comments on this. Do u think the reason
>> >might be that these interfaces are hidden behind a HAL layer like
>> >in android and
>> >might not be a burning issue for many people.
>> >
>>
>> Dmitry, could you let us know your thoughts on this too.
>> Would using a HAL layer be better compared to creating a standard
>> sysfs interface, as it seems to be the popular approach.
>>
>
> Hemanth,
>
> I do not really see the difference between sysfs interface and HAL
> interface. They both abstract hardware details and bring them to common
> denominator. If you guys can agree on HAL interface I trust sysfs should
> be possible too ;)
>
> BTW, the reason I do not comment on sysfs accelerometer infrastructure
> is because it is not topic I am vested in, my time budget barely covers
> pure input matters. So as long as there is something that is common and
> shared between drivers I would be good with it; you guys need to decide
> on details, please.
>

Dmitry, thanks for the clarification, just wanted to make sure everyone is
on the same page.

As you had suggested, I will push the cma3000 driver without the sysfs
interface. I will parallely work with Jonathan to come up with a standard
sysfs interface.

Thanks
Hemanth 

