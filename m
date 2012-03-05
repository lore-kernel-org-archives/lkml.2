Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab2CEIof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 03:44:35 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60186 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755120Ab2CEIod convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 03:44:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of amit.kachhap@linaro.org designates 10.152.134.200 as permitted sender) smtp.mail=amit.kachhap@linaro.org
MIME-Version: 1.0
In-Reply-To: <4F520CCE.1030409@gmail.com>
References: <1330772767-16120-1-git-send-email-amit.kachhap@linaro.org>
	<1330772767-16120-3-git-send-email-amit.kachhap@linaro.org>
	<4F520CCE.1030409@gmail.com>
Date: Mon, 5 Mar 2012 14:14:31 +0530
Message-ID: <CAK44p217-ah2HPot65nctZ7+r+A_EiOXPKq8y33NbBM1scrXgQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] hwmon: exynos4: Move thermal sensor driver to
 driver/mfd directory
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        eduardo.valentin@ti.com, durgadoss.r@intel.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 March 2012 17:51, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> On 03/03/2012 12:06 PM, Amit Daniel Kachhap wrote:
>>
>> This movement is needed because the hwmon entries and corresponding
>> sysfs interface is a duplicate of utilities already provided by
>> driver/thermal/thermal_sys.c. The goal is to place it in mfd folder
>> and add necessary calls to get the temperature information.
>>
>> Signed-off-by: Amit Daniel Kachhap<amit.kachhap@linaro.org>
>> Signed-off-by: Donggeun Kim<dg77.kim@samsung.com>
>> ---
>>  Documentation/hwmon/exynos4_tmu |   81 ------
>>  Documentation/mfd/exynos4_tmu   |   81 ++++++
>>  drivers/hwmon/Kconfig           |   10 -
>>  drivers/hwmon/Makefile          |    1 -
>>  drivers/hwmon/exynos4_tmu.c     |  514
>> ---------------------------------------
>>  drivers/mfd/Kconfig             |   10 +
>>  drivers/mfd/Makefile            |    1 +
>>  drivers/mfd/exynos4_tmu.c       |  514
>> +++++++++++++++++++++++++++++++++++++++
>>  8 files changed, 606 insertions(+), 606 deletions(-)
>>  delete mode 100644 Documentation/hwmon/exynos4_tmu
>>  create mode 100644 Documentation/mfd/exynos4_tmu
>>  delete mode 100644 drivers/hwmon/exynos4_tmu.c
>>  create mode 100644 drivers/mfd/exynos4_tmu.c
>
>
> Please consider adding -M option to git format-patch next time, which
> would make the patch smaller and would let to see clearly what's moved
> and what has changed.

Sure , will keep it in mind.

Thanks

>
> --
> Thanks,
> Sylwester
