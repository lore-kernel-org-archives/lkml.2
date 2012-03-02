Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369Ab2CBLlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:41:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42898 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964797Ab2CBLln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:41:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of sshtylyov@mvista.com designates 10.204.136.219 as permitted sender) smtp.mail=sshtylyov@mvista.com
Message-ID: <4F50B1A7.60207@ru.mvista.com>
Date: Fri, 02 Mar 2012 15:40:23 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 4/8] ARM: tegra: build localtimer support only when needed
References: <1330630010-11241-1-git-send-email-alan@signal11.us> <1330630010-11241-5-git-send-email-alan@signal11.us>
In-Reply-To: <1330630010-11241-5-git-send-email-alan@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-03-2012 23:26, Alan Ott wrote:

> From: Arnd Bergmann<arnd@arndb.de>

> It is possible to build a tegra kernel without localtimer
> support, so the tegra specific parts should only be built
> when that is indeed enabled.

> Signed-off-by: Arnd Bergmann<arnd@arndb.de>
> ---
>   arch/arm/mach-tegra/Makefile |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)

> diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
> index e120ff5..a956df8 100644
> --- a/arch/arm/mach-tegra/Makefile
> +++ b/arch/arm/mach-tegra/Makefile
> @@ -13,7 +13,8 @@ obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
>   obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= pinmux-tegra20-tables.o
>   obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= pinmux-tegra30-tables.o
>   obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
> -obj-$(CONFIG_SMP)                       += platsmp.o localtimer.o headsmp.o
> +obj-$(CONFIG_SMP)                       += platsmp.o headsmp.o

   Could use the chance to indent here with tabs instead of spaces, like below.

> +obj-$(CONFIG_LOCAL_TIMERS)		+= localtimer.o

WBR, Sergei
