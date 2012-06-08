Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab2FHBkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:40:23 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:64953 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759827Ab2FHBkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:40:21 -0400
Message-ID: <4FD157B1.8050509@snapgear.com>
Date: Fri, 8 Jun 2012 11:38:57 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        Philippe De Muyter <phdm@macqel.be>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] m68k: Move CPU_HAS_* config options
References: <1339094827-12349-1-git-send-email-geert@linux-m68k.org> <1339094827-12349-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1339094827-12349-2-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/12 04:47, Geert Uytterhoeven wrote:
> They belong together with the CPU selection
>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Acked-by: Greg Ungerer<gerg@uclinux.org>

Regards
Greg


>   arch/m68k/Kconfig     |    9 ---------
>   arch/m68k/Kconfig.cpu |    9 +++++++++
>   2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
> index bc8cc50..87b504c 100644
> --- a/arch/m68k/Kconfig
> +++ b/arch/m68k/Kconfig
> @@ -53,15 +53,6 @@ config ZONE_DMA
>   	bool
>   	default y
>
> -config CPU_HAS_NO_BITFIELDS
> -	bool
> -
> -config CPU_HAS_NO_MULDIV64
> -	bool
> -
> -config CPU_HAS_ADDRESS_SPACES
> -	bool
> -
>   config HZ
>   	int
>   	default 1000 if CLEOPATRA
> diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
> index 2b53254..6cd8c1a 100644
> --- a/arch/m68k/Kconfig.cpu
> +++ b/arch/m68k/Kconfig.cpu
> @@ -360,6 +360,15 @@ config NODES_SHIFT
>   	default "3"
>   	depends on !SINGLE_MEMORY_CHUNK
>
> +config CPU_HAS_NO_BITFIELDS
> +	bool
> +
> +config CPU_HAS_NO_MULDIV64
> +	bool
> +
> +config CPU_HAS_ADDRESS_SPACES
> +	bool
> +
>   config FPU
>   	bool
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
