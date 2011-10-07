Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab1JGDrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:47:37 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56070 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab1JGDrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:47:36 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-6-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-6-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 7 Oct 2011 11:47:15 +0800
Message-ID: <CAMPhdO8JMKc8kfBRUPs=80as37z8Gavrt+EEOGYyGMUnG1WHbw@mail.gmail.com>
Subject: Re: [PATCH 05/26] ARM: pxa: make zylonite_pxa*_init declaration match code
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
> When support for zylonite is disabled, the zylonite_pxa300_init
> and zylonite_pxa320_init functions are not there, but the declaration
> is still kept around if any other boards for the same soc are
> enabled. This changes the declaration to be conditional on the
> same symbol as the code.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.

> ---
>  arch/arm/mach-pxa/include/mach/zylonite.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/include/mach/zylonite.h b/arch/arm/mach-pxa/include/mach/zylonite.h
> index ea24998..ecca976 100644
> --- a/arch/arm/mach-pxa/include/mach/zylonite.h
> +++ b/arch/arm/mach-pxa/include/mach/zylonite.h
> @@ -19,7 +19,7 @@ extern int wm9713_irq;
>  extern int lcd_id;
>  extern int lcd_orientation;
>
> -#ifdef CONFIG_CPU_PXA300
> +#ifdef CONFIG_MACH_ZYLONITE300
>  extern void zylonite_pxa300_init(void);
>  #else
>  static inline void zylonite_pxa300_init(void)
> @@ -29,7 +29,7 @@ static inline void zylonite_pxa300_init(void)
>  }
>  #endif
>
> -#ifdef CONFIG_CPU_PXA320
> +#ifdef CONFIG_MACH_ZYLONITE320
>  extern void zylonite_pxa320_init(void);
>  #else
>  static inline void zylonite_pxa320_init(void)
> --
> 1.7.5.4
>
>
