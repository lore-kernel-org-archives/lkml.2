Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab2EHUQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:16:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab2EHUQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:16:18 -0400
Date: Tue, 8 May 2012 13:16:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, durgadoss.r@intel.com,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v3 0/6] thermal: exynos: Add kernel thermal support for
 exynos platform
Message-Id: <20120508131616.f60c1f90.akpm@linux-foundation.org>
In-Reply-To: <1336493898-7039-1-git-send-email-amit.kachhap@linaro.org>
References: <1336493898-7039-1-git-send-email-amit.kachhap@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 May 2012 21:48:12 +0530
Amit Daniel Kachhap <amit.kachhap@linaro.org> wrote:

> This patchset introduces a new generic cooling device based on cpufreq that
> can be used on non-ACPI platforms. As a proof of concept, we have drivers for
> the following platforms using this mechanism now:
> 
>  * TI OMAP (git://git.linaro.org/people/amitdanielk/linux.git omap4460_thermal)
>  * Samsung Exynos (Exynos4 and Exynos5) in the current patchset.
>  * Freescale i.MX (git://git.linaro.org/people/amitdanielk/linux.git imx6q_thermal)
> 
> These patches have been reviewed by Rui Zhang (https://lkml.org/lkml/2012/4/9/448)

But we don't have explicit Reviewed-by:s for the changelogs?

> who seems to agree with them in principle, but I haven't had any luck getting them
> merged, perhaps a lack of maintainer bandwidth.
> 
> ACPI platforms currently have such a mechanism but it is wrapped in ACPI'isms
> that we don't have on ARM platforms. If this is accepted, I'm proposing to
> convert over the ACPI thermal driver to use this common code too.
