Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1JHKVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 06:21:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55864 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1JHKVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 06:21:18 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-25-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-25-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 8 Oct 2011 18:20:57 +0800
Message-ID: <CAMPhdO9hTC0_30Oxc+ndn5EstOEMQKa7E_MEf4jn7ipTBbhBfw@mail.gmail.com>
Subject: Re: [PATCH 24/26] ARM: pxa: centro and treo680 need palm27x
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Marek Vasut <marek.vasut@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The two platforms are part of the palm27x family and use the same
> code. Select the palm27x symbol to make sure they can be built
> standalone.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.

> ---
>  arch/arm/mach-pxa/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
> index 568b7f6..da6fca0 100644
> --- a/arch/arm/mach-pxa/Kconfig
> +++ b/arch/arm/mach-pxa/Kconfig
> @@ -431,6 +431,7 @@ config MACH_CENTRO
>        bool "Palm Centro 685 (GSM)"
>        default y
>        depends on ARCH_PXA_PALM
> +       select MACH_PALM27X
>        select PXA27x
>        select IWMMXT
>        select PALM_TREO
> @@ -442,6 +443,7 @@ config MACH_TREO680
>        bool "Palm Treo 680"
>        default y
>        depends on ARCH_PXA_PALM
> +       select MACH_PALM27X
>        select PXA27x
>        select IWMMXT
>        select PALM_TREO
> --
> 1.7.5.4
>
>
