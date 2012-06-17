Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2FQX4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 19:56:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14252 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab2FQX4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 19:56:33 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-8e-4fde6ead917c
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, sbkim01@gmail.com
References: <042301cd493e$8d95d7e0$a8c187a0$@com>
 <20120613174620.GD7804@opensource.wolfsonmicro.com>
 <04ad01cd49c0$df565d20$9e031760$@com>
 <20120617185305.GD4267@opensource.wolfsonmicro.com>
In-reply-to: <20120617185305.GD4267@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 5/5] regulator: Support AP watchdog reset operation for
 s5m8767a
Date: Mon, 18 Jun 2012 08:56:29 +0900
Message-id: <065501cd4ce4$d07c8b90$7175a2b0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1MunEsYdsK5E+KRh+gAY66ymu0TwAKEr9A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd21eff8DX7etba4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZbU0zWAp6OCq+z7vH0sC4iK2LkZNDQsBE4uG+hVC2mMSFe+uB
	bC4OIYFFjBKH9/5ihXDmMknsfHCdCaSKTUBDYuXut0BVHBwiAmYSPw/ygISZBbIknk4/DlV/
	lFFi29wVYPWcAg4Sk77tArOFBcIkft3+zAhiswioSjxacJAZxOYVMJTYdf0OK4QtKPFj8j0W
	iKFaEut3HmeCsOUlNq95ywyyV0JAXeLRX12QsIiAkcSr72vZIEpEJPa9eMc4gVFoFpJJs5BM
	moVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAfyM+kdjKsaLA4xCnAwKvHw
	nki+5y/EmlhWXJl7iFGCg1lJhPd6OFCINyWxsiq1KD++qDQntfgQozQHi5I4b5P1BX8hgfTE
	ktTs1NSC1CKYLBMHp1QDY/09gUuvH719zbN5Y8VS4QfSTtXpM5U3zb+9842AgSr73pP3Ge99
	WL3FX3OtSNzKD1a2Dc0ekoeZmX+d/L11k06un+/6D7JLnhse2eFvlvbv7tJCJq7sqY8m3z7J
	vk6+6M3eqlcFOR63jySHfz/16/DFba8OdCkldrZGZSwJ7+prddigd8Ur+bgSS3FGoqEWc1Fx
	IgCwe15eYAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2012 at 3:53 AM, Mark Brown wrote:
> > Solution
> > - Basic concept: After ap watchdog reset, GPIO configuration is
> > changed by default value
> > - S5M8767A has function of voltage control with gpio (8 levels with 3
> > gpios)
> > - Set bootable voltage on level 0 -> can work with default gpio
> > configuration
> > - In the probing, Change voltage control level from level 0 to level 1
> > - Execute normal dvfs operation on level 1
> > - After watchdog reset, ap gpio is set by default value
> > - PMIC operation mode is changed by ap reset (level1 -> level0)
> > - AP can execute normal boot
> 
> OK, so basically what you're doing is fixing one of the GPIO selected voltage levels so that when
> the AP comes out of reset it'll drive the PMIC into a suitable level for it to boot?  That makes
> sense 
That's right.
The voltage of S5M8767A can be controlled by GPIO.
So, I try to check the status of gpio.
I will resend above patch with adding detail commit message.

Thanks,
Sangbeom.

