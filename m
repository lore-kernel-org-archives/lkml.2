Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2BHNyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:54:46 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:43054 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111Ab2BHNyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:54:43 -0500
Message-ID: <4F327E78.2040207@st.com>
Date: Wed, 08 Feb 2012 14:54:00 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] [trivial] stmmac: Fix typo in stmmac_pci.c
References: <1328702901-2157-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1328702901-2157-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Masanari.

Peppe

On 2/8/2012 1:08 PM, Masanari Iida wrote:
> Correct spelling "regiser" to "register" in
> drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> index c796de9..6ce0706 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> @@ -85,7 +85,7 @@ static int __devinit stmmac_pci_probe(struct pci_dev *pdev,
>  			continue;
>  		addr = pci_iomap(pdev, i, 0);
>  		if (addr == NULL) {
> -			pr_err("%s: ERROR: cannot map regiser memory, aborting",
> +			pr_err("%s: ERROR: cannot map register memory, aborting",
>  			       __func__);
>  			ret = -EIO;
>  			goto err_out_map_failed;

