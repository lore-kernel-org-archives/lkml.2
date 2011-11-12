Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1KLAUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 19:20:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:52450 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752874Ab1KLAUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 19:20:14 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/TV05Wy/PTU/m7ZlJCx7ylm4hmmwQSSl6ckIjo8m
	yRXFk1uQrX8qQo
Message-ID: <4EBDBBC7.1010207@gmx.de>
Date: Sat, 12 Nov 2011 00:20:23 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-fbdev@vger.kernel.org, linux-m68k@vger.kernel.org,
        "Christian T. Steigies" <cts@debian.org>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Ingo_J=FCrgensmann?= <ij@2011.bluespice.org>
Subject: Re: [PATCH 1/4] zorro: Rename Picasso IV Z2 "MEM" to "RAM" for consistency
References: <1319110945-25684-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1319110945-25684-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied all four patches.


Thanks,

Florian Tobias Schandinat

On 10/20/2011 11:42 AM, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  include/linux/zorro_ids.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/zorro_ids.h b/include/linux/zorro_ids.h
> index 7e74908..74bc53b 100644
> --- a/include/linux/zorro_ids.h
> +++ b/include/linux/zorro_ids.h
> @@ -360,8 +360,8 @@
>  #define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_RAM	ZORRO_ID(VILLAGE_TRONIC, 0x0B, 0)
>  #define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_REG	ZORRO_ID(VILLAGE_TRONIC, 0x0C, 0)
>  #define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_SEGMENTED_MODE	ZORRO_ID(VILLAGE_TRONIC, 0x0D, 0)
> -#define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z2_MEM1		ZORRO_ID(VILLAGE_TRONIC, 0x15, 0)
> -#define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z2_MEM2		ZORRO_ID(VILLAGE_TRONIC, 0x16, 0)
> +#define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z2_RAM1		ZORRO_ID(VILLAGE_TRONIC, 0x15, 0)
> +#define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z2_RAM2		ZORRO_ID(VILLAGE_TRONIC, 0x16, 0)
>  #define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z2_REG		ZORRO_ID(VILLAGE_TRONIC, 0x17, 0)
>  #define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z3		ZORRO_ID(VILLAGE_TRONIC, 0x18, 0)
>  #define  ZORRO_PROD_VILLAGE_TRONIC_ARIADNE			ZORRO_ID(VILLAGE_TRONIC, 0xC9, 0)

