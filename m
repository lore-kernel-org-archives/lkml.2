Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0KISV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:21:56 -0500
Received: from imr4.ericy.com ([198.24.6.8]:57321 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab0KISVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:21:52 -0500
Subject: Re: [PATCH v2] hwmon: (gpio-fan) Fix fan_ctrl_init error path
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Simon Guinot <sguinot@lacie.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
In-Reply-To: <1289292108.28671.1.camel@mola>
References: <1289292108.28671.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 9 Nov 2010 10:20:56 -0800
Message-ID: <1289326856.22931.211.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 03:41 -0500, Axel Lin wrote:
> In current implementation, the sysfs entries is not removed before return -ENODEV.
> 
> Creating the sysfs attribute should be the last thing done by the function,
> after all the rest has been successful.
> Otherwise there is a small window during which user-space can access the attribute
> but the driver isn't ready to deal with the requests.
> 
> Fix it by moving sysfs_create_group to be the last thing done by the function.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.

Thanks,
Guenter


