Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab0JAMrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:47:16 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:50664 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0JAMrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:47:14 -0400
Date: Fri, 1 Oct 2010 22:47:23 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: trivial@kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/2 v4]Update broken web addresses in arch directory.
In-Reply-To: <1285854709-7488-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.OSX.2.00.1010012003540.382@localhost>
References: <1285854709-7488-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Sep 2010, Justin P. Mattock wrote:

> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -647,7 +647,7 @@ config ARCH_S3C2410
>  	select HAVE_S3C2410_I2C
>  	help
>  	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
> -	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
> +	  BAST (<http://www.simtec.co.uk/products/EB110ATX/>), the IPAQ 1940 or

This is not the same board, and not the same CPU.

The old URL is not archived anywhere that I can see. I guess you could 
change this paragraph to read something like, "...such as the Simtec 
Electronics BAST (EB110ITX), the IPAQ 1940 or..." if you want to.


>  	  the Samsung SMDK2410 development board (and derivatives).
>  
>  	  Note, the S3C2416 and the S3C2450 are so close that they even share

> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 939bccd..c0bcfb8 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -105,7 +105,7 @@ config MACH_ONEARM
>  	bool "Ajeco 1ARM Single Board Computer"
>  	help
>  	  Select this if you are using Ajeco's 1ARM Single Board Computer.
> -	  <http://www.ajeco.fi/products.htm>
> +	  <http://www.ajeco.fi/index.php?language=fin>

Please use http://www.ajeco.fi/


>  
>  config ARCH_AT91RM9200DK
>  	bool "Atmel AT91RM9200-DK Development board"

> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> index a0a2928..c1a68af 100644
> --- a/arch/arm/mm/Kconfig
> +++ b/arch/arm/mm/Kconfig
> @@ -314,7 +314,7 @@ config CPU_SA110
>  	  The Intel StrongARM(R) SA-110 is a 32-bit microprocessor and
>  	  is available at five speeds ranging from 100 MHz to 233 MHz.
>  	  More information is available at
> -	  <http://developer.intel.com/design/strong/sa110.htm>.
> +	  <http://www.renan.org/ARM/doc/sa110.pdf>.

This is in the web archive. Also, the original link is not the datasheet.


>  
>  	  Say Y if you want support for the SA-110 processor.
>  	  Otherwise, say N.
> diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
> index 1407597..25d03fa 100644
> --- a/arch/arm/mm/proc-xscale.S
> +++ b/arch/arm/mm/proc-xscale.S
> @@ -418,7 +418,7 @@ ENTRY(xscale_cache_fns)
>   *
>   * See erratum #25 of "Intel 80200 Processor Specification Update",
>   * revision January 22, 2003, available at:
> - *     http://www.intel.com/design/iio/specupdt/273415.htm
> + *     http://www.intel.com/design/support/faq/io_processors/iq80310_chipset.htm

There were no errata at your URL that I could see. Also the old URL with 
errata are in the web archive.


>   */
>  ENTRY(xscale_80200_A0_A1_cache_fns)
>  	.long	xscale_flush_kern_cache_all

>   * Copyright (c) 2008 Simtec Electronics
> - *	http://armlinux.simnte.co.uk/
> + *	http://armlinux.simtec.co.uk/	
>   *	Ben Dooks <ben@simtec.co.uk>
>   *
>   * S3C ADC driver information
> diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
> index f515727..787dcba 100644
> --- a/arch/avr32/Kconfig
> +++ b/arch/avr32/Kconfig
> @@ -145,7 +145,7 @@ config BOARD_HAMMERHEAD
>  	  will cover even the most exceptional need of memory bandwidth. Together with the onboard
>  	  video decoder the board is ready for video processing.
>  
> -	  For more information see: http://www.miromico.com/hammerhead
> +	  For more information see: http://www.hammerhead.ch/index.php/getting-started.html 

I think this probably is the same page:

http://www.miromico.ch/index.php/hammerhead.html


>  
>  config BOARD_FAVR_32
>  	bool "Favr-32 LCD-board"


> diff --git a/arch/h8300/Kconfig.cpu b/arch/h8300/Kconfig.cpu
> index 6e2ecff..8de966a 100644
> --- a/arch/h8300/Kconfig.cpu
> +++ b/arch/h8300/Kconfig.cpu
> @@ -49,15 +49,15 @@ config H8S_EDOSK2674
>  	help
>  	  Renesas EDOSK-2674 Evaluation Board Support
>  	  More Information.
> -	  <http://www.azpower.com/H8-uClinux/index.html>

This page is in the web archive archive, and there isn't really any 
substitute that I can see, so keep this link.


> - 	  <http://www.eu.renesas.com/tools/edk/support/edosk2674.html>
> +	  <http://h8-uclinux.sourceforge.net/>
> + 	  <http://www.renesas.eu/products/tools/introductory_evaluation_tools/evaluation_development_os_kits/edosk2674r/edosk2674r_software_tools_root.jsp>
>  

> diff --git a/arch/h8300/README b/arch/h8300/README
> index 2fd6f6d..7dac451 100644
> --- a/arch/h8300/README
> +++ b/arch/h8300/README
> @@ -14,11 +14,11 @@ H8/300H and H8S

>  4.EDOSK2674
> -  see http://www.eu.renesas.com/products/mpumcu/tool/edk/support/edosk2674.html
> -      http://www.azpower.com/H8-uClinux/
> +  see http://www.uclinux.org/pub/uClinux/ports/h8/HITACHI-EDOSK2674-HOWTO 
> +      http://h8-uclinux.sourceforge.net/

Same here.

Also, the renesas URL that you used above wouldn't hurt.


>  
>  * Toolchain Version
>  gcc-3.1 or higher and patch

> diff --git a/arch/m68k/mac/macboing.c b/arch/m68k/mac/macboing.c
> index 8f06408..234d9ee 100644
> --- a/arch/m68k/mac/macboing.c
> +++ b/arch/m68k/mac/macboing.c
> @@ -114,7 +114,8 @@ static void mac_init_asc( void )
>  			 *   16-bit I/O functionality.  The PowerBook 500 series computers
>  			 *   support 16-bit stereo output, but only mono input."
>  			 *
> -			 *   http://til.info.apple.com/techinfo.nsf/artnum/n16405
> +			 *   "Technical Information Library (TIL) article number 16405". 


No need for the quote marks.


> +			 *   http://support.apple.com/kb/TA32601 
>  			 *
>  			 * --David Kilzer
>  			 */


Thanks.

Finn
