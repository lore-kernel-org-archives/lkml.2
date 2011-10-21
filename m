Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1JUFYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 01:24:33 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:34891 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1JUFYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 01:24:31 -0400
Message-ID: <4EA100EA.9030503@snapgear.com>
Date: Fri, 21 Oct 2011 15:19:38 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-m68k@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: drop unused Kconfig symbols
References: <1319109836.8405.30.camel@x61.thuisdomein>
In-Reply-To: <1319109836.8405.30.camel@x61.thuisdomein>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Paul, applied.

Regards
Greg


On 20/10/11 21:23, Paul Bolle wrote:
> Reported-by: Geert Uytterhoeven<geert@linux-m68k.org>
> Signed-off-by: Paul Bolle<pebolle@tiscali.nl>
> ---
> "git grep" tested only.
>
>   arch/m68k/Kconfig |   24 +-----------------------
>   1 files changed, 1 insertions(+), 23 deletions(-)
>
> diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
> index 58c6496..3e673ac 100644
> --- a/arch/m68k/Kconfig
> +++ b/arch/m68k/Kconfig
> @@ -163,35 +163,13 @@ config HPAPCI
>   	  If you want to use the internal "APCI" serial ports on an HP400
>   	  machine, say Y here.
>
> -config MVME147_SCC
> -	bool "SCC support for MVME147 serial ports"
> -	depends on MVME147&&  BROKEN
> -	help
> -	  This is the driver for the serial ports on the Motorola MVME147
> -	  boards.  Everyone using one of these boards should say Y here.
> -
> -config MVME162_SCC
> -	bool "SCC support for MVME162 serial ports"
> -	depends on MVME16x&&  BROKEN
> -	help
> -	  This is the driver for the serial ports on the Motorola MVME162 and
> -	  172 boards.  Everyone using one of these boards should say Y here.
> -
> -config BVME6000_SCC
> -	bool "SCC support for BVME6000 serial ports"
> -	depends on BVME6000&&  BROKEN
> -	help
> -	  This is the driver for the serial ports on the BVME4000 and BVME6000
> -	  boards from BVM Ltd.  Everyone using one of these boards should say
> -	  Y here.
> -
>   config DN_SERIAL
>   	bool "Support for DN serial port (dummy)"
>   	depends on APOLLO
>
>   config SERIAL_CONSOLE
>   	bool "Support for serial port console"
> -	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO)&&  (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || MULTIFACE_III_TTY=y || SERIAL=y || MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
> +	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO)&&  (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || MULTIFACE_III_TTY=y || SERIAL=y || SERIAL167 || DN_SERIAL)
>   	---help---
>   	  If you say Y here, it will be possible to use a serial port as the
>   	  system console (the system console is the device which receives all


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
