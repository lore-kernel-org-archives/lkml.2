Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2CCMVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 07:21:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38259 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab2CCMVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 07:21:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of snjw23@gmail.com designates 10.213.113.20 as permitted sender) smtp.mail=snjw23@gmail.com; dkim=pass header.i=snjw23@gmail.com
Message-ID: <4F520CCE.1030409@gmail.com>
Date: Sat, 03 Mar 2012 13:21:34 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
CC: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        eduardo.valentin@ti.com, durgadoss.r@intel.com, patches@linaro.org
Subject: Re: [PATCH 2/4] hwmon: exynos4: Move thermal sensor driver to driver/mfd
 directory
References: <1330772767-16120-1-git-send-email-amit.kachhap@linaro.org> <1330772767-16120-3-git-send-email-amit.kachhap@linaro.org>
In-Reply-To: <1330772767-16120-3-git-send-email-amit.kachhap@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2012 12:06 PM, Amit Daniel Kachhap wrote:
> This movement is needed because the hwmon entries and corresponding
> sysfs interface is a duplicate of utilities already provided by
> driver/thermal/thermal_sys.c. The goal is to place it in mfd folder
> and add necessary calls to get the temperature information.
>
> Signed-off-by: Amit Daniel Kachhap<amit.kachhap@linaro.org>
> Signed-off-by: Donggeun Kim<dg77.kim@samsung.com>
> ---
>   Documentation/hwmon/exynos4_tmu |   81 ------
>   Documentation/mfd/exynos4_tmu   |   81 ++++++
>   drivers/hwmon/Kconfig           |   10 -
>   drivers/hwmon/Makefile          |    1 -
>   drivers/hwmon/exynos4_tmu.c     |  514 ---------------------------------------
>   drivers/mfd/Kconfig             |   10 +
>   drivers/mfd/Makefile            |    1 +
>   drivers/mfd/exynos4_tmu.c       |  514 +++++++++++++++++++++++++++++++++++++++
>   8 files changed, 606 insertions(+), 606 deletions(-)
>   delete mode 100644 Documentation/hwmon/exynos4_tmu
>   create mode 100644 Documentation/mfd/exynos4_tmu
>   delete mode 100644 drivers/hwmon/exynos4_tmu.c
>   create mode 100644 drivers/mfd/exynos4_tmu.c

Please consider adding -M option to git format-patch next time, which
would make the patch smaller and would let to see clearly what's moved
and what has changed.

--
Thanks,
Sylwester
