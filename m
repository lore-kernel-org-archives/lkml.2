Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab2INEEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 00:04:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29391 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2INEEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 00:04:01 -0400
X-AuditID: cbfee61a-b7fb46d00000656d-09-5052acae3b48
From: kgene@kernel.org
To: "'Peter Senna Tschudin'" <peter.senna@gmail.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1347469402-27557-9-git-send-email-peter.senna@gmail.com>
In-reply-to: <1347469402-27557-9-git-send-email-peter.senna@gmail.com>
Subject: RE: [PATCH 9/15] arch/arm/mach-s3c24xx/mach-h1940.c: removes
 unnecessary semicolon
Date: Fri, 14 Sep 2012 13:03:58 +0900
Message-id: <01a301cd922d$f72da600$e588f200$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2RCI8WpgoxH8R8RF6cr0LVXs6tbAAev6/A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t9jQd11a4ICDFbslLTYekva4vKuOWwW
	M87vY3Jg9vi8SS6AMYrLJiU1J7MstUjfLoErY9ef4+wFt9gqZjezNDBuZ+1i5OSQEDCR+H/3
	EDuELSZx4d56ti5GLg4hgemMEpceXIZy/jJK9K5eD9TBwcEGVDX1iTRIg7CAlsTCLU0sILaI
	QLjEocdrmEDqmQVOM0osnDCDESQhJOAq0XZyBRuIzSngJvH08E1WiOZYiS9HzzCBzGQRUJXY
	/qEUJMwrYCjRuWoyG4QtKPFj8j2w+cxAu9bvPM4EYctLbF7zlhmkVUJAXeLRX12IE4wkfu37
	B1UuIrHvxTvGCYzCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cT
	Izjcn0ntYFzZYHGIUYCDUYmHN4EnKECINbGsuDL3EKMEB7OSCK+tNlCINyWxsiq1KD++qDQn
	tfgQozQHi5I4r/CnwAAhgfTEktTs1NSC1CKYLBMHp1QDY7jyNblNyxrKOL8v/CiclbLW5699
	onByLvt5bcs9x86Uv8w447pui8yT3tdcri8rGPSm+e2bJew3fdGBINbjBS27NrTzzJZaPCVB
	piv7zIL4pGW3t17nPyi3IJPrhMFkBaFj7Z/5vsjI/7oRf6EvU76Aez/HqYOz5+bxTxcTc3jL
	dzP5u8j2+UosxRmJhlrMRcWJAMdPNZ1zAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Senna Tschudin wrote:
> 
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> removes unnecessary semicolon
> 
> Found by Coccinelle: http://coccinelle.lip6.fr/
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> ---
>  arch/arm/mach-s3c24xx/mach-h1940.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-s3c24xx/mach-h1940.c b/arch/arm/mach-
> s3c24xx/mach-h1940.c
> index bb8d008..02ef7d5 100644
> --- a/arch/arm/mach-s3c24xx/mach-h1940.c
> +++ b/arch/arm/mach-s3c24xx/mach-h1940.c
> @@ -460,7 +460,7 @@ static void h1940_set_mmc_power(unsigned char
> power_mode, unsigned short vdd)
>  		break;
>  	default:
>  		break;
> -	};
> +	}
>  }
> 
>  static struct s3c24xx_mci_pdata h1940_mmc_cfg __initdata = {

Applied, thanks.

K-Gene <kgene@kernel.org>

