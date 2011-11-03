Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab1KCPTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:19:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62419 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab1KCPT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:19:29 -0400
Message-ID: <4EB2B0FD.309@gmail.com>
Date: Thu, 03 Nov 2011 17:19:25 +0200
From: =?UTF-8?B?TGFycyBOb29kw6lu?= <lars.nooden@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: guenter.roeck@ericsson.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: Re: Hardware running hot and without the fan
References: <4EB1108F.6070009@gmail.com>  <20111103020301.GA22333@ericsson.com> <4EB250FD.3070000@gmail.com>  <20111103134902.GA26121@ericsson.com>  <4EB2A46B.8080600@gmail.com> <1320332801.2309.60.camel@groeck-laptop>
In-Reply-To: <1320332801.2309.60.camel@groeck-laptop>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 05:06 PM, Guenter Roeck wrote:
> On Thu, 2011-11-03 at 10:25 -0400, Lars Noodén wrote:
[snip]
>> The one machine reports one fan and the other two fans.  I haven't found
>> a way to set the fan speed manually.  The output from sensors
>> is
>>  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593/comments/44
>> and here
>>  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593/comments/47
> 
> Do the fans actually turn, or is the output bogus ?

The output is bogus, the fans are not turning.  On #47 there above, I
think the temperatures might be inaccurate, too.  Since they'll go up
and down as much as 8 degrees in a few seconds.

> You should be able to set the fan speed by writing into the fanX_input
> and/or fanX_output sysfs attributes. You find those
> in /sys/class/hwmon/hwmon0/device (assuming there is only one hwmon
> device).

I can set the fan speed manually.  e.g.:

 echo 3500 > /sys/class/hwmon/hwmon0/device/fan1_output

That helps some.

/Lars
