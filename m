Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2KACE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 22:04:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46996 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2KACE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 22:04:27 -0400
Message-ID: <5091D8A8.9010307@gmail.com>
Date: Wed, 31 Oct 2012 21:04:24 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Russell King <linux@arm.linux.org.uk>, Matt Porter <mporter@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm-dt: Enable DT proc updates.
References: <1351699069-4661-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1351699069-4661-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 10:57 AM, Pantelis Antoniou wrote:
> This simple patch enables dynamic changes of the DT tree on runtime
> to be visible to the device-tree proc interface.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  arch/arm/include/asm/prom.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
> index aeae9c6..6d65ba2 100644
> --- a/arch/arm/include/asm/prom.h
> +++ b/arch/arm/include/asm/prom.h
> @@ -11,6 +11,8 @@
>  #ifndef __ASMARM_PROM_H
>  #define __ASMARM_PROM_H
>  
> +#define HAVE_ARCH_DEVTREE_FIXUPS
> +
>  #ifdef CONFIG_OF
>  
>  extern struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
> 

