Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab2CGTK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:10:58 -0500
Received: from imr4.ericy.com ([198.24.6.9]:52296 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759051Ab2CGTK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:10:57 -0500
Message-ID: <1331147302.23014.370.camel@groeck-laptop>
Subject: Re: [PATCH 02/03] HWMON: HWMON driver for DA9052/53 PMIC v3
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
CC: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "dchen@diasemi.com" <dchen@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Date: Wed, 7 Mar 2012 11:08:22 -0800
In-Reply-To: <1330698545.21817.31.camel@dhruva>
References: <1330698545.21817.31.camel@dhruva>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 09:29 -0500, Ashish Jangam wrote:
> The DA9052 PMIC provides an Analogue to Digital Converter with 10 bits
> resolution and 10 channels.
> 
> This patch monitors the DA9052 PMIC's ADC channels mostly for battery
> parameters like battery temperature, junction temperature, battery
> current etc.
> 
> This patch is functionally tested on Samsung SMDKV6410
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>

Only comment I would have is that it might make sense to use
DIV_ROUND_CLOSEST(). That is a minor issue, though, so feel free to add

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

Question is where this is going. I can not add it to hwmon-next without
the matching mfd changes. Any idea ?

Thanks,
Guenter


