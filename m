Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab0KLPEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:04:13 -0500
Received: from kroah.org ([198.145.64.141]:41480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932300Ab0KLPEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:04:11 -0500
Date: Fri, 12 Nov 2010 07:03:16 -0800
From: Greg KH <greg@kroah.com>
To: Hemanth V <hemanthv@ti.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Jean Delvare <khali@linux-fr.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, drivers@analog.com,
        achew@nvidia.com, Donggeun Kim <dg77.kim@samsung.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Sensor event related attribute naming.
Message-ID: <20101112150316.GB18096@kroah.com>
References: <7BC12C510D794F198DFA5A5C104CD7B6@wipblrx0099946>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7BC12C510D794F198DFA5A5C104CD7B6@wipblrx0099946>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 03:34:36PM +0530, Hemanth V wrote:
> ----- Original Message ----- From: "Hemanth V" <hemanthv@ti.com>
> To: "Jonathan Cameron" <jic23@cam.ac.uk>; "Dmitry Torokhov" <dtor@mail.ru>
>
>
>> ----- Original Message ----- From: "Jonathan Cameron" <jic23@cam.ac.uk>
>> To: "Jonathan Cameron" <jic23@cam.ac.uk>
>> Sent: Thursday, September 30, 2010 3:36 PM
>> Subject: Re: Sensor event related attribute naming.
>>
>>
>>> Given the lack of further comment, I went ahead and implemented the above 
>>> naming
>>> scheme for IIO. As the above discussion with Hemanth shows, there are 
>>> some corner cases
>>> that will need futher thought in the future.
>>>
>>
>> Jonathan, haven't seen many comments on this. Do u think the reason
>> might be that these interfaces are hidden behind a HAL layer like in 
>> android and
>> might not be a burning issue for many people.
>>
>
> Dmitry, could you let us know your thoughts on this too.
> Would using a HAL layer be better compared to creating a standard
> sysfs interface, as it seems to be the popular approach.

What "HAL layer"?  HAL the userspace project is now dead, so you should
standardize on a common sysfs or some other user/kernel api that the
kernel exports for the same type of devices to make it so that
everything works the same way.

thanks,

greg k-h
