Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab1KJBet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:34:49 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30592 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab1KJBer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:34:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6525"; a="133911554"
Message-ID: <4EBB2A36.9040609@codeaurora.org>
Date: Wed, 09 Nov 2011 17:34:46 -0800
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111103 Thunderbird/8.0
MIME-Version: 1.0
To: Harini Jayaraman <harinij@codeaurora.org>
CC: grant.likely@secretlab.ca, davidb@codeaurora.org, kheitke@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: QUP based bus driver for Qualcomm MSM chipsets
References: <y> <1320887221-7165-1-git-send-email-harinij@codeaurora.org>
In-Reply-To: <1320887221-7165-1-git-send-email-harinij@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 05:07 PM, Harini Jayaraman wrote:
> This bus driver supports the QUP SPI hardware controller in the Qualcomm
> MSM SOCs. The Qualcomm Universal Peripheral Engine (QUP) is a general
> purpose data path engine with input/output FIFOs and an embedded SPI
> mini-core. The driver currently supports only FIFO mode.
> 
> Signed-off-by: Harini Jayaraman <harinij@codeaurora.org>
> ---
>  drivers/spi/Kconfig                   |   10 +
>  drivers/spi/Makefile                  |    1 +
>  drivers/spi/msm_spi_qsd.h             |  436 +++++++++++++
>  drivers/spi/spi-qsd.c                 | 1144 +++++++++++++++++++++++++++++++++
>  include/linux/platform_data/msm_spi.h |   19 +
>  5 files changed, 1610 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/spi/msm_spi_qsd.h
>  create mode 100644 drivers/spi/spi-qsd.c
>  create mode 100644 include/linux/platform_data/msm_spi.h

A few high-level comments to start.  Let's drop 'qsd' from all the
names.  We haven't used that naming convention for several years now.
Better to just call this 'spi-qup.[ch]'.  Also, please update the
copyright dates.  This driver existed before 2011.  Thanks.

- Bryan

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
