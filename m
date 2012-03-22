Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab2CVNmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 09:42:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38287 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab2CVNmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 09:42:04 -0400
MIME-Version: 1.0
In-Reply-To: <1331029648-29175-1-git-send-email-torne@google.com>
References: <1331029648-29175-1-git-send-email-torne@google.com>
Date: Thu, 22 Mar 2012 13:42:03 +0000
Message-ID: <CAEV-rjcyk6wTLRiwDiErUk5XM7jt8VNH4Hk2CRrx5AzmP_Df+A@mail.gmail.com>
Subject: Re: [PATCH] MMC: sdhci: remove too large timeout warning
From: "Torne (Richard Coles)" <torne@google.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Torne (Richard Coles)" <torne@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.. anyone interested in this patch? :) It's been a couple weeks
with no response.

It still applies cleanly to the current tree.

On 6 March 2012 10:27, Torne (Richard Coles) <torne@google.com> wrote:
> From: "Torne (Richard Coles)" <torne@google.com>
>
> Some MMC cards specify timeouts that are larger than the highest
> possible timeout in the host controller. sdhci is the only host
> controller driver which complains about this; remove the warning to
> match the behaviour of the other drivers.
>
> Signed-off-by: Torne (Richard Coles) <torne@google.com>
> ---
>  drivers/mmc/host/sdhci.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 8d66706..85d4d05 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -680,8 +680,6 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
>        }
>
>        if (count >= 0xF) {
> -               pr_warning("%s: Too large timeout requested for CMD%d!\n",
> -                      mmc_hostname(host->mmc), cmd->opcode);
>                count = 0xE;
>        }
>
> --
> 1.7.7.3
>



-- 
Torne (Richard Coles)
torne@google.com
