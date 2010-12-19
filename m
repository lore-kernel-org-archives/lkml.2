Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab0LSE6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 23:58:37 -0500
Received: from imr3.ericy.com ([198.24.6.13]:54688 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab0LSE6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 23:58:36 -0500
Date: Sat, 18 Dec 2010 20:55:20 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "Brown, Len" <len.brown@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Patch[1/2] Adding_threshold_support_to_coretemp
Message-ID: <20101219045520.GA16890@ericsson.com>
References: <D6D887BA8C9DFF48B5233887EF04654105C1173BCD@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <D6D887BA8C9DFF48B5233887EF04654105C1173BCD@bgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 09:09:59AM -0500, R, Durgadoss wrote:
> Hi,
> 
> I am submitting a patch to enable core thermal threshold
> Support to coretemp.c. There are two core thermal thresholds
> available through sysfs interfaces temp1_max and temp1_max_hyst.
> The temp1_max_alarm is set when temperature reaches or crosses
> above temp1_max or drops below temp1_max_hyst.
> 
> This patch is generated against stable Linux-2.6 kernel.
> 
> Kindly review and merge.
> ----------------------------------------------------------------
> From: Durgadoss R <durgadoss.r@intel.com>
> 
> Date: Sat, 18 Dec 2010 06:45:41 +0530
> Subject: PATCH[1/2] Adding_Threshold_Support_to_Coretemp
> 
> This patch adds core thermal threshold support to coretemp.
> These thresholds can be configured via the sysfs interfaces temp1_max
> and temp1_max_hyst. An interrupt is generated when CPU temperature reaches
> or crosses above temp1_max and drops below temp1_max_hyst.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> 
Unfortunately, with this headline and description, the x86 folks will probably
not even look at your patch, since they won't suspect that x86 platform code
is affected.

I would suggest to split this patch in two parts, one affecting the x86 code
and the second for the hwmon code. The headline for the x86 patch should show
that it is a x86 patch, ie the text should start with x86: (and the hwmon
patches should really start with hwmon: for hwmon patches).

Guenter
