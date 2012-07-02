Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab2GBSKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:10:52 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49140 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GBSKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:10:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaNDW+XCrf9Mse-N3jtgtrrx9Z0+W1YZX8nPETa7ZZFB1w@mail.gmail.com>
References: <1341218420-22377-1-git-send-email-devendra.aaru@gmail.com>
	<CAK5ve-JaNGoWuCTP5ddMEEfpA3ucWNL_ayj5ULU3+++5a02pWw@mail.gmail.com>
	<CAHdPZaNDW+XCrf9Mse-N3jtgtrrx9Z0+W1YZX8nPETa7ZZFB1w@mail.gmail.com>
Date: Mon, 2 Jul 2012 23:40:50 +0530
Message-ID: <CAHdPZaNSqiUg2Vq_CXYGX9wa1E_rJKFT3POL-_Yqu1SEYvLoyA@mail.gmail.com>
Subject: Re: [PATCH] leds-mc13783: set platform data to NULL at mc13783_led_remove
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

I Made all the necessary changes, and it touched 21 drivers overall,
and i compile tested all except leds-sunfire as i dont have a
cross-toolchain for that.
all patches are compile tested with

gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3, ( my machine's)
arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-2012.05-20120523 -
Linaro GCC 2012.05) 4.7.1 20120514 (prerelease) (ARM toolchain's)

at each cross-compile of a driver i selected the defconfig of each
machine, fox ex. for leds-netxbig i chose kirkwood-defconfig, and for
leds-s3c24xx i chose s3c2410_defconfig.

Now i have only 1 question in mind :).

do i need to submit all in a single patch? or patch per driver?

Thanks,
Devendra.
