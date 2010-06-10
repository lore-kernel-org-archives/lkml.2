Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab0FJQdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:33:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37460 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab0FJQdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=paUPrA5/CBX1LG2l6EIozFJz8mhT4gUpJN0xtR+huc3Uca/gpuv3ETThqKzE7pPvlq
         3cQWMTqUUUjlDuzOS6Bj3S8bp1p/1ghZh7aBrIVC1JvalAKkllFLTqUhr+1fgejVv0Jr
         ZPwAWSnNwk3Bc7aOMAo/CCqnKjMzFaGbJCrdo=
MIME-Version: 1.0
In-Reply-To: <2f41f9174bd6ba24b5609e06e87c47d5f44446d1.1275925108.git.siccegge@cs.fau.de>
References: <cover.1275925108.git.siccegge@cs.fau.de>
	<2f41f9174bd6ba24b5609e06e87c47d5f44446d1.1275925108.git.siccegge@cs.fau.de>
Date: Thu, 10 Jun 2010 10:33:14 -0600
Message-ID: <AANLkTilBd1ei3SYtBlpc9KQIz8vgXxa9rpA2wZCxq0qL@mail.gmail.com>
Subject: Re: [PATCH 9/9] Removing dead CONFIG_MTD_PMC_MSP_RAMROOT
From: Shane McDonald <mcdonald.shane@gmail.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Yoichi Yuasa <yuasa@linux-mips.org>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 5:23 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
>
> CONFIG_MTD_PMC_MSP_RAMROOT doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
>
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  .../mips/include/asm/pmc-sierra/msp71xx/msp_prom.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>
> diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_prom.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_prom.h
> index 54ef1a9..786d82d 100644
> --- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_prom.h
> +++ b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_prom.h
> @@ -124,10 +124,6 @@ extern void prom_meminit(void);
>  extern void prom_fixup_mem_map(unsigned long start_mem,
>                               unsigned long end_mem);
>
> -#ifdef CONFIG_MTD_PMC_MSP_RAMROOT
> -extern bool get_ramroot(void **start, unsigned long *size);
> -#endif
> -
>  extern int get_ethernet_addr(char *ethaddr_name, char *ethernet_addr);
>  extern unsigned long get_deviceid(void);
>  extern char identify_enet(unsigned long interface_num);
> --
> 1.6.3.3

  Good catch!  This should have been included in the patch that
removed the CONFIG_MTD_PMC_MSP_RAMROOT functionality:
http://www.linux-mips.org/archives/linux-mips/2009-05/msg00024.html

Acked-by: Shane McDonald <mcdonald.shane@gmail.com>
