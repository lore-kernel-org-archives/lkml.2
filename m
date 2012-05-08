Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab2EHUQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:16:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab2EHUQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:16:34 -0400
Date: Tue, 8 May 2012 13:16:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, durgadoss.r@intel.com,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v3 3/6] hwmon: exynos4: Move thermal sensor driver to
 driver/thermal directory
Message-Id: <20120508131632.49d0ac99.akpm@linux-foundation.org>
In-Reply-To: <1336493898-7039-4-git-send-email-amit.kachhap@linaro.org>
References: <1336493898-7039-1-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-2-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-3-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-4-git-send-email-amit.kachhap@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 May 2012 21:48:15 +0530
Amit Daniel Kachhap <amit.kachhap@linaro.org> wrote:

> This movement is needed because the hwmon entries and corresponding
> sysfs interface is a duplicate of utilities already provided by
> driver/thermal/thermal_sys.c. The goal is to place it in thermal folder
> and add necessary functions to use the in-kernel thermal interfaces.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> ---
>  Documentation/hwmon/exynos4_tmu              |   81 ----
>  Documentation/thermal/exynos_thermal         |   52 +++
>  drivers/hwmon/Kconfig                        |   10 -
>  drivers/hwmon/Makefile                       |    1 -
>  drivers/hwmon/exynos4_tmu.c                  |  514 --------------------------

Please cc the hwmon people?  Jean Delvare <khali@linux-fr.org>, Guenter
Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org

>  drivers/thermal/Kconfig                      |    9 +
>  drivers/thermal/Makefile                     |    1 +
>  drivers/thermal/exynos_thermal.c             |  409 ++++++++++++++++++++
>  include/linux/platform_data/exynos4_tmu.h    |   83 ----
>  include/linux/platform_data/exynos_thermal.h |   83 ++++

