Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab0IXPVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 11:21:04 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:52351 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab0IXPVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 11:21:01 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.89
Message-ID: <4C9CC219.4090304@tremplin-utc.net>
Date: Fri, 24 Sep 2010 17:22:01 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100917 Mandriva/3.1.4-1mdv2011.0 (2011.0) Thunderbird/3.1.4
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Takashi Iwai <tiwai@suse.de>, Guenter Roeck <guenter.roeck@ericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH v2] lis3: Fix Oops with NULL platform data
References: <s5heiclngqe.wl%tiwai@suse.de>	<20100924135802.GA18109@ericsson.com>	<s5hlj6r1b5p.wl%tiwai@suse.de> <20100924163005.7704f63e@endymion.delvare>
In-Reply-To: <20100924163005.7704f63e@endymion.delvare>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 24-09-10 16:30, Jean Delvare schreef:
> Well, as long as the driver lives in drivers/hwmon and the hwmon
> subsystem is maintained, it seems fair to consider the driver
> maintained.
> 
> That being said, I indeed would like all non-hwmon drivers to go away
> from drivers/hwmon. Originally we were waiting for iio to settle first,
> but apparently this is taking forever. The 4 drivers I would like to
> kick are: ams, hdaps, lis3lv02d and applesmc. They are primarily
> accelerometer device drivers. Not sure where to put them,
> drivers/accel(erometer), drivers/misc, drivers/misc/accel(erometer),
> drivers/input/accel(erometer)... Opinions welcome.
As maintainer of the lis3lv02d driver, I'd completely support the move too.

IMHO, an accelerometer is just another input device (usually with 2 or 3
axes), so moving them to drivers/input/accel would make sense.

Eric
