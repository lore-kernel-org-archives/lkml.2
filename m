Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1EQJcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:32:22 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:55835 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab1EQJcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:32:21 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DD24131.2030009@cam.ac.uk>
Date: Tue, 17 May 2011 10:34:41 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
CC: fabien.marteau@armadeus.com, Guenter Roeck <guenter.roeck@ericsson.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: Driver for as1531, Austria-Microsystem Analog
 to Digital Converter.
References: <fabien.marteau@armadeus.com> <1305553154-18195-2-git-send-email-fabien.marteau@armadeus.com> <20110516153900.GA31255@ericsson.com> <4DD21E5E.9000605@armadeus.com> <4DD23EED.4010201@cam.ac.uk>
In-Reply-To: <4DD23EED.4010201@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/11 10:25, Jonathan Cameron wrote:
> On 05/17/11 08:06, Fabien Marteau wrote:
>> Hi Guenter,
>>
>> Thanks for the review.
>>
>> On 16/05/2011 17:39, Guenter Roeck wrote:
>>> On Mon, May 16, 2011 at 09:39:14AM -0400, fabien.marteau@armadeus.com wrote:
>>>> From: Fabien Marteau <fabien.marteau@armadeus.com>
>>>>
>>>>
>>> Some description, such as "Dhis driver adds support for xxx" would be nice.
>>>
>>> Also, I wonder if this driver belongs into hwmon in the first place. It is
>>> a generic ADC chip with high conversion rate. iio would probably be more
>>> appropriate and also much better in supporting high speed readings.
>> I provided this driver "as is" because it's a driver that work well on
>> our platform. I thought that iio was not stable enough driver framework
>> to be used.
>> I can rewrite it under iio framework but I have no time for this moment
>> to do that. You think it's better to wait for an iio driver or to
>> continue commiting this ?
> I'd say that if you primary use is hwmon, put it there for now and we can think
> about moving it at a later date depending on how people are actually using it.
> Guenter, would that be ok for you?
Having actually taken a look at the code, it's straight forward, so if you
are using it as a general purpose adc then I'm happy to port to IIO
sometimes soonish...  Will need some testing at somepoint though.

Jonathan
