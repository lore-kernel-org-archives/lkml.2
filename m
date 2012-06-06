Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab2FFR57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:57:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58878 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2FFR56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:57:58 -0400
Subject: Re: [PATCH] ARM: mx35: add WEIM register addresses
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Christian Hemp <c.hemp@phytec.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>
In-Reply-To: <20120509131638.GA2057@lovely.krouter>
References: <20120509131638.GA2057@lovely.krouter>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 06 Jun 2012 19:57:51 +0200
Message-ID: <1339005471.10948.317.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 15:16 +0200, Christoph Fritz wrote:
> This patch adds WEIM register addresses to mx35 platform header file.
> 
> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
> Signed-off-by: Christian Hemp <c.hemp@phytec.de>
> ---
>  arch/arm/plat-mxc/include/mach/mx35.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/include/mach/mx35.h b/arch/arm/plat-mxc/include/mach/mx35.h
> index 80965a9..8b8f424 100644
> --- a/arch/arm/plat-mxc/include/mach/mx35.h
> +++ b/arch/arm/plat-mxc/include/mach/mx35.h
> @@ -111,6 +111,11 @@
>  #define MX35_EMI_CTL_BASE_ADDR			(MX35_X_MEMC_BASE_ADDR + 0x4000)
>  #define MX35_PCMCIA_CTL_BASE_ADDR		MX35_EMI_CTL_BASE_ADDR
>  
> +#define MX35_WEIM_CSCRx_BASE_ADDR(cs)	(MX35_WEIM_BASE_ADDR + (cs) * 0x10)
> +#define MX35_WEIM_CSCRxU(cs)		(MX35_WEIM_CSCRx_BASE_ADDR(cs))
> +#define MX35_WEIM_CSCRxL(cs)		(MX35_WEIM_CSCRx_BASE_ADDR(cs) + 0x4)
> +#define MX35_WEIM_CSCRxA(cs)		(MX35_WEIM_CSCRx_BASE_ADDR(cs) + 0x8)
> +
>  #define MX35_NFC_BASE_ADDR		0xbb000000
>  #define MX35_PCMCIA_MEM_BASE_ADDR	0xbc000000
>  

ping

