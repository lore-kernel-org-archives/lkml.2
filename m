Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab1FNFUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:20:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32350 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab1FNFUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:20:21 -0400
X-AuditID: cbfee61b-b7c62ae0000056ed-66-4df6ef9379ca
Date: Tue, 14 Jun 2011 14:20:14 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH] dma-mapping: Undefine dma_map_single(),
 etc if CONFIG_HAVE_DMA_ATTRS is defined
In-reply-to: <1308025989-877-1-git-send-email-pullip.cho@samsung.com>
To: pullip.cho@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: arnd@arndb.de, fujita.tomonori@lab.ntt.co.jp, rmk@arm.linux.org.uk,
        joerg.roedel@amd.com
Message-id: <005501cc2a52$c05df650$4119e2f0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcwqT98PPspThvKbTqiM3Z7L93nCCwAAOAHw
References: <1308025989-877-1-git-send-email-pullip.cho@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pullip.cho@samsung.com wrote:
> 
> From: KyongHo Cho <pullip.cho@samsung.com>
> 
> If <asm/dma-mapping.h> includes <asm-generic/dma-mapping-common.h>,
> dma_map_single() become defined recursively when CONFIG_HAVE_DMA_ATTRS
> is not defined.
> Since dma_map_*_attrs() are defined in <linux/dma-mapping.h>, those
> in <asm-generic/dma-mapping-common.h> must be not defined
> if CONFIG_HAVE_DMA_ATTRS is not defined.
> 
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
> CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> CC: Joerg Roedel <joerg.roedel@amd.com>
> CC Arnd Bergmann <arnd@arndb.de>
> 
> Change-Id: Ib99ee2b355dbe679263ce2e4e27d6219148c8338

Please don't use this here.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

