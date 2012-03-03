Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2CCPAg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 10:00:36 -0500
Received: from imr3.ericy.com ([198.24.6.13]:35203 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab2CCPAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 10:00:35 -0500
Date: Sat, 3 Mar 2012 06:55:38 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
CC: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [lm-sensors] [PATCH 3/4] thermal: exynos4: Register the tmu
 sensor with the thermal interface layer
Message-ID: <20120303145538.GB29335@ericsson.com>
References: <1330772767-16120-1-git-send-email-amit.kachhap@linaro.org>
 <1330772767-16120-4-git-send-email-amit.kachhap@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1330772767-16120-4-git-send-email-amit.kachhap@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 06:06:06AM -0500, Amit Daniel Kachhap wrote:
> Export and register information from the tmu temperature sensor to the samsung
> exynos kernel thermal framework where different cooling devices and thermal
> zone are binded. The exported information is based according to the data
> structure thermal_sensor_conf present in exynos_thermal.h. HWMON sysfs
> functions are removed as all of them are present in generic linux thermal layer.
> 
> Also the platform data structure is modified to pass frequency cooling
> in percentages for each thermal level.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>

Ah, that is what I meant. I don't think it makes sense to have this as separate patch.

Guenter
