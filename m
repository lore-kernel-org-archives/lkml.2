Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0IYLCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 07:02:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17103 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab0IYLCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 07:02:08 -0400
Date: Sat, 25 Sep 2010 13:01:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        =?ISO-8859-1?B?yXJpYw==?= Piel <Eric.Piel@tremplin-utc.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH v2] lis3: Fix Oops with NULL platform data
Message-ID: <20100925130125.049401a0@endymion.delvare>
In-Reply-To: <4C9CBF4E.7080200@cam.ac.uk>
References: <s5heiclngqe.wl%tiwai@suse.de>
	<20100924135802.GA18109@ericsson.com>
	<s5hlj6r1b5p.wl%tiwai@suse.de>
	<20100924163005.7704f63e@endymion.delvare>
	<4C9CBF4E.7080200@cam.ac.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 16:10:06 +0100, Jonathan Cameron wrote:
> On 09/24/10 15:30, Jean Delvare wrote:
> > That being said, I indeed would like all non-hwmon drivers to go away
> > from drivers/hwmon. Originally we were waiting for iio to settle first,
> > but apparently this is taking forever.
> More developers and code reviewers always welcome!

Just to clear any confusion: this wasn't a criticism from my side. I
understand why it takes time. All I mean is that it is not reasonable
to delay other changes waiting for IIO to hit mainline. Because we have
no idea when that will happen.

> > The 4 drivers I would like to
> > kick are: ams, hdaps, lis3lv02d and applesmc. They are primarily
> > accelerometer device drivers. Not sure where to put them,
> > drivers/accel(erometer), drivers/misc, drivers/misc/accel(erometer),
> > drivers/input/accel(erometer)... Opinions welcome.
> If the primary use is as an input device then talk to Dmitry. Some
> accelerometers are being taken into input. There are some open questions
> on naming etc currently being debated so anyone interested should get
> involved in those asap.

Let's see if he wants them. I seem to recall he objected to them going
to input, on the basis that the input function was a not the key
feature. But apparently we have one accel driver in drivers/input/misc
(adxl34x) so maybe we can have more.

-- 
Jean Delvare
