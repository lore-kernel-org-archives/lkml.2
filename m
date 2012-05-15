Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966728Ab2EOUQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:16:42 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43933 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966104Ab2EOUQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:16:40 -0400
Message-ID: <4FB2B9A8.1060103@kernel.org>
Date: Tue, 15 May 2012 21:16:40 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120314 Thunderbird/11.0
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, Rob Landley <rob@landley.net>,
        Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3] iio: add LM3533 ambient-light-sensor driver
References: <1336040799-18433-3-git-send-email-jhovold@gmail.com> <1337100396-29024-1-git-send-email-jhovold@gmail.com> <20120515122705.42461e7e.akpm@linux-foundation.org> <20120515200027.GA9132@localhost>
In-Reply-To: <20120515200027.GA9132@localhost>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 09:00 PM, Johan Hovold wrote:
> On Tue, May 15, 2012 at 12:27:05PM -0700, Andrew Morton wrote:
>> On Tue, 15 May 2012 18:46:36 +0200
>> Johan Hovold <jhovold@gmail.com> wrote:
>>
>>> Add sub-driver for the ambient-light-sensor interface on National
>>> Semiconductor / TI LM3533 lighting power chips.
>>>
>>> The sensor interface can be used to control the LEDs and backlights of
>>> the chip through defining five light zones and three sets of
>>> corresponding brightness target levels.
>>>
>>> The driver provides raw and mean adc readings along with the current
>>> light zone through sysfs. A threshold event can be generated on zone
>>> changes.
>>>
>>> ...
>>>
>>>  drivers/staging/iio/light/Kconfig                  |   16 +
>>>  drivers/staging/iio/light/Makefile                 |    1 +
>>>  drivers/staging/iio/light/lm3533-als.c             |  726 ++++++++++++++++++++
>>
>> Why is this aimed at drivers/staging/, rather than directly into
>> drivers/iio/?
> 
> I understood it as it was only iio core which was moving out of staging
> in 3.5, but I see now that some drivers have been added directly to
> driver/iio. My mistake.
It was more a case that the core was the priority.  Drivers would if
ready and people had time to do the patches!
> 
> I'll make sure to move it to drivers/iio/light.
Yup, that's sensible for a new driver like this.  I'll be even fussier
about the userspace interfaces though ;)

> 
> Thanks for pointing it out,
> Johan

