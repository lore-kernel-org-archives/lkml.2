Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab0JVUJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:09:19 -0400
Received: from imr4.ericy.com ([198.24.6.8]:56371 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab0JVUJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:09:17 -0400
Subject: Re: [PATCH 00/12] lis3 accelerator feature update
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 22 Oct 2010 13:08:16 -0700
Message-ID: <1287778096.9690.401.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 07:57 -0400, Samu Onkalo wrote:
> Changes are tested only with I2C interface using 8bit sensor since I don't
> have other possibilities. Some features are not enabled
> by default since I can't test them with all possible configurations.
> Platform data contains field which controls new features.
> 
[ ... ]
> 
> Samu Onkalo (12):
>   hwmon: lis3: pm_runtime support
>   hwmon: lis3: regulator control
>   hwmon: lis3: Cleanup interrupt handling
>   hwmon: lis3: Update coordinates at polled device open
>   hwmon: lis3: Power on corrections
>   hwmon: lis3: restore axis enabled bits
>   hwmon: lis3: New parameters to platform data
>   hwmon: lis3: Adjust fuzziness for 8 bit device
>   hwmon: lis3: use block read to access data registers
>   hwmon: lis3: Enhance lis3 selftest with IRQ line test
>   hwmon: lis3: Short explanations of platform data fields
>   hwmon: lis3: Release resources is case of failure
> 
>  drivers/hwmon/lis3lv02d.c     |  304 ++++++++++++++++++++++++++++++++++------
>  drivers/hwmon/lis3lv02d.h     |   18 +++
>  drivers/hwmon/lis3lv02d_i2c.c |  127 +++++++++++++++--
>  drivers/hwmon/lis3lv02d_spi.c |    2 +-
>  include/linux/lis3lv02d.h     |   50 +++++++-
>  5 files changed, 439 insertions(+), 62 deletions(-)
> 
Eric, can you Ack this series ?

Guenter


