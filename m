Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab2AaOsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:48:08 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61658 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab2AaOsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:48:06 -0500
MIME-Version: 1.0
In-Reply-To: <1328006193-13902-1-git-send-email-k.lewandowsk@samsung.com>
References: <1328006193-13902-1-git-send-email-k.lewandowsk@samsung.com>
Date: Tue, 31 Jan 2012 20:18:05 +0530
Message-ID: <CAJuYYwQepKi+TG1tOaZ=X9WEi3cwbwsoofuZBSqSiBb4LA_YoA@mail.gmail.com>
Subject: Re: [PATCH 0/2] EXYNOS4_DT fixes for 3.3-rc1+ kernels
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: m.szyprowski@samsung.com, linux-samsung-soc@vger.kernel.org,
        marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karol,

On 31 January 2012 16:06, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
> Device Tree-based Exynos4 machine prepared by Thomas Abraham and
> included in 3.3-rc1 hasn't been adjusted to changes that have happened
> to mach-exynos during 3.3 merge window.
>
> Following patch series fixes one build and one boot error making it
> possible to boot system with SMP disabled.
>
> SMP support is still broken for unknown reason, though.
>
> [ To use it it's also required to cherry-pick "ARM: EXYNOS: fix
>  non-SMP builds for EXYNOS4" already found in kgene's
>  linux-samsung.git (branch v3.3-samsung-fixes-2) ]
>
>
> Karol Lewandowski (2):
>  ARM: Exynos4: Make exynos4-dt compile again
>  ARM: Exynos4: Convert exynos4-dt to CONFIG_MULTI_IRQ_HANDLER
>
>  arch/arm/mach-exynos/mach-exynos4-dt.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)

Thanks for these patches and identifying the issue.

Regards,
Thomas.

> --
> 1.7.8.3
>
