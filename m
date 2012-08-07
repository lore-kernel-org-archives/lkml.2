Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2HGJVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:21:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64368 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab2HGJVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:21:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] ARM: kirkwood: fix typo in Makefile.boot
Date: Tue, 7 Aug 2012 09:21:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
References: <1344177932-6466-1-git-send-email-sebastian.hesselbarth@googlemail.com>
In-Reply-To: <1344177932-6466-1-git-send-email-sebastian.hesselbarth@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208070921.35459.arnd@arndb.de>
X-Provags-ID: V02:K0:EYVjKEj+b0gVM1q5SH33FBFedqjWWOMNFQ8aU52Y16K
 e4FYUXdoN5cowYRNnQepXABQCmC5vN7EO/kQIlRKtjC9You2WQ
 WoCYaEFgpvfUlk3p8n+fbZ/ayhJMq1Dm0sM4eawB2EpgdniVt6
 dO1cehcRf/4r9LK33Q8FuapBz9eZ5QYT0M60aNpOhvWs/YEZRH
 97V7Bltg8TUNhnorAl0tVYH33qgXlldP9VVo/aJEfrG5vRoJEy
 xNKhoIp+Ivmub6XDghq3qH1cD+iRhEeGLzHxVfcpbbIMQHAwFB
 9o0eMZtaJ6o8LA9VI5WCatlXM7jO7jExX5iLVXKTY4CEPXRaVW
 XiJzt0YcKPiDr1P8vnj8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 August 2012, Sebastian Hesselbarth wrote:
> Just a small typo fix to make lsxl dtbs compile
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-kirkwood/Makefile.boot |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-kirkwood/Makefile.boot b/arch/arm/mach-kirkwood/Makefile.boot
> index 2a576ab..a571755 100644
> --- a/arch/arm/mach-kirkwood/Makefile.boot
> +++ b/arch/arm/mach-kirkwood/Makefile.boot
> @@ -9,5 +9,5 @@ dtb-$(CONFIG_MACH_ICONNECT_DT) += kirkwood-iconnect.dtb
>  dtb-$(CONFIG_MACH_IB62X0_DT) += kirkwood-ib62x0.dtb
>  dtb-$(CONFIG_MACH_TS219_DT)	+= kirkwood-qnap-ts219.dtb
>  dtb-$(CONFIG_MACH_GOFLEXNET_DT) += kirkwood-goflexnet.dtb
> -dbt-$(CONFIG_MACH_LSXL_DT) += kirkwood-lschlv2.dtb
> -dbt-$(CONFIG_MACH_LSXL_DT) += kirkwood-lsxhl.dtb
> +dtb-$(CONFIG_MACH_LSXL_DT) += kirkwood-lschlv2.dtb
> +dtb-$(CONFIG_MACH_LSXL_DT) += kirkwood-lsxhl.dtb

As Jason and Andrew are both currently unavailable, I'm applying this directly
to the fixes branch in arm-soc.

	Arnd
