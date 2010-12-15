Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0LOPgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:36:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0LOPgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:36:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/7] msm: Board file for MSM8960 simulator
Date: Wed, 15 Dec 2010 16:36:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org> <1292384961-8851-5-git-send-email-stepanm@codeaurora.org>
In-Reply-To: <1292384961-8851-5-git-send-email-stepanm@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151636.19868.arnd@arndb.de>
X-Provags-ID: V02:K0:mlyYmSGj0+ByWo1/eZfK4g9F1M0+x4hEvnvKRDQ8H2e
 iTmMOV7D/XTWxgvQ1DjJiqNug51vrnsus3PeNiQxU4MwHyuo4M
 woslsDvLr08d4YBw1jVKSdWcAvzoOziuaid8nAE2NpdJcPyrTe
 ryz/pvJq5X9/VfuMCexqLzKEnT8W+nsOsOGlbAwTdaPpEqj2Ma
 7wZBR1lYyMv+lXVj2cjcA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 December 2010, Stepan Moskovchenko wrote:
> +#ifdef CONFIG_MSM_DEBUG_UART
> +       .phys_io  = MSM_DEBUG_UART_PHYS,
> +       .io_pg_offst = ((MSM_DEBUG_UART_BASE) >> 18) & 0xfffc,
> +#endif

These fields are no longer present in the machine description,
AFAICT.

	Arnd
