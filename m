Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab1GAQje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:39:34 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:57446 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757139Ab1GAQjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:39:32 -0400
From: Nathan Royer <nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com> <4E0D8E94.5030604@cam.ac.uk>
In-Reply-To: <4E0D8E94.5030604@cam.ac.uk>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Acw3zVTzKEfyNEHnTlyTQ9Df/ml3tgAPviPg
Date: Fri, 1 Jul 2011 09:39:30 -0700
Message-ID: <4d61a92a11e5d83a1cb0094441ae5f5e@mail.gmail.com>
Subject: RE: [PATCH 01/11] misc: inv_mpu primary header file and README file.
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just out of interest, can you give details of what other patches are to
> come?
> I'm guessing more sensor drivers and I hate discovering I'm
> implementing drivers
> for devices that someone already has working code for!

I wanted to start off with only 1 driver for each type of slave and with
only the MPU3050 and exclude the MPU6050 until we figure out exactly the
best way to fit this into the kernel.

The current full list of drivers we have developed in this architecture
are as follows:
MPU3050 and MPU6050 support in mldl_cfg.c
# sesnors - accel
accel/mpu6050.c
accel/kxsd9.c
accel/kxtf9.c
accel/bma150.c
accel/bma222.c
accel/bma250.c
accel/mma8450.c
accel/mma845x.c
accel/lis331.c
accel/lsm303a.c
accel/adxl34x.c
accel/lis3dh.c
# sensors - compass
compass/ak8975.c
compass/ak8972.c
compass/ami30x.c
compass/ami306.c
compass/hmc5883.c
compass/lsm303m.c
compass/yas529.c
compass/yas530.c
compass/mmc314x.c
compass/hscdtd002b.c
compass/hscdtd004a.c
# sensors - pressure
pressure/bma085.c
