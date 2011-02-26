Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab1BZSZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 13:25:31 -0500
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:34943 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1BZSZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 13:25:29 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D6945A1.1030807@cam.ac.uk>
Date: Sat, 26 Feb 2011 18:25:37 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg Schnorr <gschnorr@cisco.com>,
        lm-sensors@lm-sensors.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/5] hwmon: PMBus device driver
References: <1298742650-9789-1-git-send-email-guenter.roeck@ericsson.com> <1298742650-9789-2-git-send-email-guenter.roeck@ericsson.com>
In-Reply-To: <1298742650-9789-2-git-send-email-guenter.roeck@ericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/11 17:50, Guenter Roeck wrote:
> This driver adds support for hardware monitoring features of various PMBus
> devices.
> 
I'm happy with changes/responses to comments so ready to merge as far as
I am concerned.
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/hwmon/Kconfig      |   25 +
>  drivers/hwmon/Makefile     |    4 +
>  drivers/hwmon/pmbus.c      |  203 ++++++
>  drivers/hwmon/pmbus.h      |  313 +++++++++
>  drivers/hwmon/pmbus_core.c | 1628 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/pmbus.h  |   45 ++
>  6 files changed, 2218 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/pmbus.c
>  create mode 100644 drivers/hwmon/pmbus.h
>  create mode 100644 drivers/hwmon/pmbus_core.c
>  create mode 100644 include/linux/i2c/pmbus.h
...
