Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab1JaDuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 23:50:21 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:61116 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1JaDuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 23:50:19 -0400
Message-ID: <4EAE1B3A.7010303@snapgear.com>
Date: Mon, 31 Oct 2011 13:51:22 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Ungerer <gerg@uclinux.org>, <linux-m68k@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Revive lost DIO bus config option
References: <1319835295-19519-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1319835295-19519-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 29/10/11 06:54, Geert Uytterhoeven wrote:
> commit 0e152d80507b75c00aac60f2ffc586360687cd52 ("m68k: reorganize Kconfig
> options to improve mmu/non-mmu selections") accidentally dropped the DIO
> bus config option. Re-add it to the "Bus support" section.
>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Oops, another one.

Acked-by: Greg Ungerer <gerg@uclinux.org>

Are you going to push these to Linus, or do you want me to
collect these fixes and push?

Regards
Greg


>   arch/m68k/Kconfig.bus |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/arch/m68k/Kconfig.bus b/arch/m68k/Kconfig.bus
> index 7703b54..983e176 100644
> --- a/arch/m68k/Kconfig.bus
> +++ b/arch/m68k/Kconfig.bus
> @@ -2,6 +2,15 @@ if MMU
>
>   comment "Bus Support"
>
> +config DIO
> +	bool "DIO bus support"
> +	depends on HP300
> +	default y
> +	help
> +	  Say Y here to enable support for the "DIO" expansion bus used in
> +	  HP300 machines. If you are using such a system you almost certainly
> +	  want this.
> +
>   config NUBUS
>   	bool
>   	depends on MAC


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
