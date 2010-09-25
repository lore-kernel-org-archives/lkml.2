Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0IYNlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 09:41:49 -0400
Received: from ppsw-31.csi.cam.ac.uk ([131.111.8.131]:40299 "EHLO
	ppsw-31.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0IYNls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 09:41:48 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C9DFD59.6000708@cam.ac.uk>
Date: Sat, 25 Sep 2010 14:47:05 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH v2] lis3: Fix Oops with NULL platform data
References: <s5heiclngqe.wl%tiwai@suse.de>	<20100924135802.GA18109@ericsson.com>	<s5hlj6r1b5p.wl%tiwai@suse.de>	<20100924163005.7704f63e@endymion.delvare>	<4C9CBF4E.7080200@cam.ac.uk> <20100925130125.049401a0@endymion.delvare>
In-Reply-To: <20100925130125.049401a0@endymion.delvare>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/10 12:01, Jean Delvare wrote:
> On Fri, 24 Sep 2010 16:10:06 +0100, Jonathan Cameron wrote:
>> On 09/24/10 15:30, Jean Delvare wrote:
>>> That being said, I indeed would like all non-hwmon drivers to go away
>>> from drivers/hwmon. Originally we were waiting for iio to settle first,
>>> but apparently this is taking forever.
>> More developers and code reviewers always welcome!
> 
> Just to clear any confusion: this wasn't a criticism from my side. I
> understand why it takes time. All I mean is that it is not reasonable
> to delay other changes waiting for IIO to hit mainline. Because we have
> no idea when that will happen.
Not to worry ;)  I was just taking advantage to drop in a plug.
It's certainly going slower than I would like and I'm fully in favour
of drivers going into misc or similar even if we would like to
eventually take them into IIO. This is part of the reason we
have been trying to pin down interface naming etc in a more
general forum than our internal list.   Basically we are trying to
avoid a repeat of the ALS debacle. 
> 
>>> The 4 drivers I would like to
>>> kick are: ams, hdaps, lis3lv02d and applesmc. They are primarily
>>> accelerometer device drivers. Not sure where to put them,
>>> drivers/accel(erometer), drivers/misc, drivers/misc/accel(erometer),
>>> drivers/input/accel(erometer)... Opinions welcome.
>> If the primary use is as an input device then talk to Dmitry. Some
>> accelerometers are being taken into input. There are some open questions
>> on naming etc currently being debated so anyone interested should get
>> involved in those asap.
> 
> Let's see if he wants them. I seem to recall he objected to them going
> to input, on the basis that the input function was a not the key
> feature. But apparently we have one accel driver in drivers/input/misc
> (adxl34x) so maybe we can have more.
Yup, Dmitry has softened somewhat on this point for device where it really
can be argued that input is the key feature (typically the ones being used
for exactly this purpose in smart phones) in recent months so things may
have changed.

Lets wait and see.

Jonathan

