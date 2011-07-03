Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab1GCLVO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 07:21:14 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:38587 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1GCLVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 07:21:12 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E105284.7030209@cam.ac.uk>
Date: Sun, 03 Jul 2011 12:29:08 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Nathan Royer <nroyer@invensense.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chris Hudson <chudson@kionix.com>, eric.andersson@unixphere.com,
        eric.miao@linaro.org
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README file.
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com> <4E0D8E94.5030604@cam.ac.uk> <4d61a92a11e5d83a1cb0094441ae5f5e@mail.gmail.com>
In-Reply-To: <4d61a92a11e5d83a1cb0094441ae5f5e@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/11 17:39, Nathan Royer wrote:
>> Just out of interest, can you give details of what other patches are to
>> come?
>> I'm guessing more sensor drivers and I hate discovering I'm
>> implementing drivers
>> for devices that someone already has working code for!
> 
> I wanted to start off with only 1 driver for each type of slave and with
> only the MPU3050 and exclude the MPU6050 until we figure out exactly the
> best way to fit this into the kernel.

With such an extensive list of drivers, how about putting the whole current
lot in staging whilst we figure out the eventual form?  Probably not including
the ones we already have else where, but maybe we do want them as well, so we
can merge in new features?
> 
> The current full list of drivers we have developed in this architecture
> are as follows:
> MPU3050 and MPU6050 support in mldl_cfg.c
> # sesnors - accel
> accel/mpu6050.c  -
> accel/kxsd9.c
There is a driver for this in IIO but it exists more as an example of a trivial
driver than being fully fledged.  We've never had any interest before in doing
anything more complex with it.   I've cc'd Chris Hudson at Kionix, to comment on
what they have for these parts.
> accel/kxtf9.c
Over to Chris.

> accel/bma150.c
An input driver exists for that one. (cc'd Eric)

> accel/bma222.c
Not seen this one or the next that I can recall.
> accel/bma250.c

> accel/mma8450.c
> accel/mma845x.c
Err, naming clash ;)
Input driver has been posted... Cc'd another Eric.

> accel/lis331.c
Supported I think by the lis driver.

> accel/lsm303a.c
Not seen that one.

> accel/adxl34x.c
input driver.
> accel/lis3dh.c
also lis driver.
> # sensors - compass
> compass/ak8975.c
> compass/ak8972.c
> compass/ami30x.c
> compass/ami306.c
> compass/hmc5883.c
> compass/lsm303m.c
> compass/yas529.c
> compass/yas530.c
> compass/mmc314x.c
> compass/hscdtd002b.c
> compass/hscdtd004a.c
That is a whole host more compasses that I haven't seen drivers for. I think
we may have 2 of them in IIO...
> # sensors - pressure
> pressure/bma085.c
As Manuel Stahl confirmed he also has a driver for this.
> 

