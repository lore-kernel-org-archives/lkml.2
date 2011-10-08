Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1JHIfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 04:35:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56323 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1JHIfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 04:35:10 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-20-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-20-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 8 Oct 2011 16:34:50 +0800
Message-ID: <CAMPhdO9VAJ+1CrXr5EgqVwc6zc4DGhZ__NS-GfvDqcw=r_WjUQ@mail.gmail.com>
Subject: Re: [PATCH 19/26] ARM: pxa: CPU_FREQ_TABLE is needed for CPU_FREQ
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The pxa specific cpufreq code is based on the cpu_freq_table
> module, so we have to select that.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.

> ---
>  arch/arm/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 71b0ccb..3b84eda 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1926,6 +1926,7 @@ config CPU_FREQ_PXA
>        bool
>        depends on CPU_FREQ && ARCH_PXA && PXA25x
>        default y
> +       select CPU_FREQ_TABLE
>        select CPU_FREQ_DEFAULT_GOV_USERSPACE
>
>  config CPU_FREQ_S3C
> --
> 1.7.5.4
>
>
