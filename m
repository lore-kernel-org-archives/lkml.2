Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799Ab1EIECF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 00:02:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1351 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1EIECC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 00:02:02 -0400
Subject: Re: [PATCH V2 2/5] pch_dma: modify for checkpatch
From: Joe Perches <joe@perches.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
In-Reply-To: <1304912406-6531-2-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1304912406-6531-1-git-send-email-tomoya-linux@dsn.okisemi.com>
	 <1304912406-6531-2-git-send-email-tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 21:02:00 -0700
Message-ID: <1304913720.19586.4.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 12:40 +0900, Tomoya MORINAGA wrote:
> Fix checkpatch warnings.
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
[]
> @@ -138,7 +138,8 @@ struct pch_dma {
> -static inline struct pch_dma_desc *to_pd_desc(struct dma_async_tx_descriptor *txd)
> +static inline struct pch_dma_desc *to_pd_desc(
> +					struct dma_async_tx_descriptor *txd)

I think these are better either not changed at all
or to either of the styles below:

static inline struct pch_dma_desc *
to_pd_desc(struct dma_async_tx_descriptor *txd)

static inline
struct pch_dma_desc *to_pd_desc(struct dma_async_tx_descriptor *txd)



