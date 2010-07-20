Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab0GTU40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:56:26 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:15451 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932072Ab0GTU4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:56:23 -0400
Message-ID: <4C460D96.70301@bluewatersys.com>
Date: Wed, 21 Jul 2010 08:56:54 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
CC: Russell King <linux@arm.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Lothar Wassmann <LW@KARO-electronics.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Bryan Wu <cooloney@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] usb/host: Remove dead CONFIG_ARCH_KARO
References: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>	<9df7166bb950e7fbc12d1be9f2b9f9cbb9961187.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>	<4C3E24DE.7050208@bluewatersys.com> <86zkxmk4vi.fsf_-_@peer.zerties.org>
In-Reply-To: <86zkxmk4vi.fsf_-_@peer.zerties.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 07:08 PM, Christian Dietrich wrote:
> 
> CONFIG_ARCH_KARO doesn't exist in Kconfig and is never defined anywhere
> else, therefore removing all references for it from the source code.
> 
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

Unless someone has a reason why the support needs to stay:

Acked-by: Ryan Mallon <ryan@bluewatersys.com>

> ---
>  drivers/usb/host/isp1362.h |   24 +-----------------------
>  1 files changed, 1 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/usb/host/isp1362.h b/drivers/usb/host/isp1362.h
> index d995351..0f97820 100644
> --- a/drivers/usb/host/isp1362.h
> +++ b/drivers/usb/host/isp1362.h
> @@ -8,29 +8,7 @@
>  /*
>   * Platform specific compile time options
>   */
> -#if defined(CONFIG_ARCH_KARO)
> -#include <asm/arch/hardware.h>
> -#include <asm/arch/pxa-regs.h>
> -#include <asm/arch/karo.h>
> -
> -#define USE_32BIT              1
> -
> -
> -/* These options are mutually eclusive */
> -#define USE_PLATFORM_DELAY    1
> -#define USE_NDELAY             0
> -/*
> - * MAX_ROOT_PORTS: Number of downstream ports
> - *
> - * The chip has two USB ports, one of which can be configured as
> - * an USB device port, so the value of this constant is implementation
> - * specific.
> - */
> -#define MAX_ROOT_PORTS         2
> -#define DUMMY_DELAY_ACCESS do {} while (0)
> -
> -/* insert platform specific definitions for other machines here */
> -#elif defined(CONFIG_BLACKFIN)
> +#if defined(CONFIG_BLACKFIN)
>  
>  #include <linux/io.h>
>  #define USE_32BIT              0


-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
