Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab2ADKXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 05:23:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:19850 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab2ADKXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 05:23:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103209170"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Amit Kachhap <amit.kachhap@linaro.org>,
        "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>,
        Donggeun Kim <dg77.kim@samsung.com>
CC: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: RE: [linux-pm] [lm-sensors] [RFC PATCH 2/3] thermal: exynos4:
 Register the tmu sensor with the thermal interface layer
Thread-Topic: [linux-pm] [lm-sensors] [RFC PATCH 2/3] thermal: exynos4:
 Register the tmu sensor with the thermal interface layer
Thread-Index: AQHMv9hopayZ5ImWw0eNRbo2kBWOy5X68WqAgADF4YCAAFyrUA==
Date: Wed, 4 Jan 2012 10:23:35 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5901B976@BGSMSX101.gar.corp.intel.com>
References: <1324468798-20423-1-git-send-email-amit.kachhap@linaro.org>
	<1324468798-20423-3-git-send-email-amit.kachhap@linaro.org>
	<1325629553.26706.11.camel@groeck-laptop>
 <CAK44p20XeLVkJyox2SsDqyy=RYgEQNpyGGypwTMPXpueQT1T3g@mail.gmail.com>
In-Reply-To: <CAK44p20XeLVkJyox2SsDqyy=RYgEQNpyGGypwTMPXpueQT1T3g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit Daniel,

> Hi Guenter,
> 
> The main idea of this work is to leave the current userspace based
> notification scheme and add the kernel based cooling scheme on top of
> it. Anyway, It is a good idea to move the file hwmon/exynos4_tmu.c as

But, What I feel is, kernel based cooling scheme will work only for
Controlling 'CPU' frequency. But in SoC's there are other devices that
Contribute to Thermal. For example, GPU, Display, Battery (during charging)
etc.. In this case, we need a user space to control these devices. So, in a
way, the user space notification mechanism is a unified solution for
throttling all devices and keeps the kernel code light weight.

I am also curious to know why the existing mechanism did not work for you ?

Thanks,
Durga

> this creates 2 hwmon entries.
> Adding CC: Donggeun Kim to know his opinion.
> 
> Thanks,
> Amit Daniel
[snip.]
