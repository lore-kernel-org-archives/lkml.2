Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab1LSBsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 20:48:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39920 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1LSBsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 20:48:22 -0500
MIME-Version: 1.0
In-Reply-To: <201112152048.06595.rjw@sisk.pl>
References: <20111215051013.GA23030@july>
	<201112152048.06595.rjw@sisk.pl>
Date: Mon, 19 Dec 2011 10:48:21 +0900
Message-ID: <CAJ0PZbRckR089G9YVLJxEe+T+M5sRR4G3B8=dRU2Pmq9SxqqTA@mail.gmail.com>
Subject: Re: [PATCH] devfreq: Add devfreq maintainer entry
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 4:48 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, December 15, 2011, Kyungmin Park wrote:
>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> As devfreq is merged at mainline. Also update the maintainer entry.
>>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> So long as you will send pull requests to me:
>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Great. Thanks.

Anyway, may I create a repository in git.kernel.org so that you can
pull patches from me?



Cheers!
MyungJoo

>
>> ---
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index b9db108..a5d2840 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -2192,6 +2192,13 @@ T:     git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
>>  S:   Maintained
>>  F:   drivers/usb/dwc3/
>>
>> +DEVICE FREQUENCY (DEVFREQ)
>> +M:   MyungJoo Ham <myungjoo.ham@samsung.com>
>> +M:   Kyungmin Park <kyungmin.park@samsung.com>
>> +L:   linux-kernel@vger.kernel.org
>> +S:   Maintained
>> +F:   drivers/devfreq/
>> +
>>  DEVICE NUMBER REGISTRY
>>  M:   Torben Mathiasen <device@lanana.org>
>>  W:   http://lanana.org/docs/device-list/index.html
>>
>>
>



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
