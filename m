Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab1L3Agk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 19:36:40 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:35292 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab1L3AgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 19:36:22 -0500
Message-ID: <4EFD075B.3090803@snapgear.com>
Date: Fri, 30 Dec 2011 10:35:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-m68k@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k/mac: Make CONFIG_HEARTBEAT unavailable on Mac
References: <1325185383-19449-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1325185383-19449-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/12/11 05:03, Geert Uytterhoeven wrote:
> mac_heartbeat() was never really implemented.
>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg


>   arch/m68k/Kconfig.devices |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
> index c3bd7e2..a8eff5a 100644
> --- a/arch/m68k/Kconfig.devices
> +++ b/arch/m68k/Kconfig.devices
> @@ -8,8 +8,8 @@ config ARCH_MAY_HAVE_PC_FDC
>   menu "Platform devices"
>
>   config HEARTBEAT
> -	bool "Use power LED as a heartbeat" if AMIGA || APOLLO || ATARI || MAC ||Q40
> -	default y if !AMIGA&&  !APOLLO&&  !ATARI&&  !MAC&&  !Q40&&  HP300
> +	bool "Use power LED as a heartbeat" if AMIGA || APOLLO || ATARI || Q40
> +	default y if !AMIGA&&  !APOLLO&&  !ATARI&&  !Q40&&  HP300
>   	help
>   	  Use the power-on LED on your machine as a load meter.  The exact
>   	  behavior is platform-dependent, but normally the flash frequency is


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
