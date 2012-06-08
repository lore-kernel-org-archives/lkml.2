Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab2FHD4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:56:36 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:56526 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab2FHD4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:56:34 -0400
Message-ID: <4FD176AE.9030903@snapgear.com>
Date: Fri, 8 Jun 2012 13:51:10 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        Philippe De Muyter <phdm@macqel.be>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] m68k: CPU32 does not support unaligned accesses
References: <1339094827-12349-1-git-send-email-geert@linux-m68k.org> <1339094827-12349-5-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1339094827-12349-5-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/12 04:47, Geert Uytterhoeven wrote:
> Hence select CPU_HAS_NO_UNALIGNED
>
> Reported-by: Philippe De Muyter<phdm@macqel.be>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Acked-by: Greg Ungerer<gerg@uclinux.org>

Regards
Greg


> ---
>   arch/m68k/Kconfig.cpu |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
> index c4ed650..d4f3a98 100644
> --- a/arch/m68k/Kconfig.cpu
> +++ b/arch/m68k/Kconfig.cpu
> @@ -50,6 +50,7 @@ config M68000
>   config MCPU32
>   	bool
>   	select CPU_HAS_NO_BITFIELDS
> +	select CPU_HAS_NO_UNALIGNED
>   	help
>   	  The Freescale (was then Motorola) CPU32 is a CPU core that is
>   	  based on the 68020 processor. For the most part it is used in


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
