Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2JAHz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 03:55:56 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:26288
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217Ab2JAHzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 03:55:55 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z551biz98dI1432Izz1202h1d1ah1d2ahzz8275dh15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB7FCZ-02-03R-02
X-M-MSG: 
Date: Mon, 1 Oct 2012 09:55:53 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Daniel J Blueman <daniel@quora.org>
CC: Ingo Molnar <mingo@redhat.com>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Correct AMD IOMMU printing
Message-ID: <20121001075553.GL4009@amd.com>
References: <1349077273-17297-1-git-send-email-daniel@quora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1349077273-17297-1-git-send-email-daniel@quora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 03:41:13PM +0800, Daniel J Blueman wrote:
> When an AMD IOMMU is detected, prevent printing unintended blank line.
> 
> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> ---
>  drivers/iommu/amd_iommu_init.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 18a89b7..49d9d32 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -1115,8 +1115,8 @@ static void print_iommu_info(void)
>  				if (iommu_feature(iommu, (1ULL << i)))
>  					pr_cont(" %s", feat_str[i]);
>  			}
> +			pr_cont("\n");
>  		}
> -		pr_cont("\n");

Sorry, you are 3 days too late with this, Borislav Petkov already
submitted a similar patch on friday.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

