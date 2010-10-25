Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0JYLaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:30:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62428 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab0JYLaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:30:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC PATCH 13/18] ARM: LPAE: ensure dma_addr_t is the same size as phys_addr_t
Date: Mon, 25 Oct 2010 13:08:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com> <20101025090046.25275.80297.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20101025090046.25275.80297.stgit@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010251308.24063.arnd@arndb.de>
X-Provags-ID: V02:K0:Ai3nEt6VCBnVsHWE51HixQbXfDOp4WUoqFb7nWbc7Vl
 ysCvtybxwmR5p/qMI2AkhiRaOGFOLmomn07C7H2mfIc7nDWiC7
 HujtwVFGgGtyx0Zl0/bWNXVvGQ1RtAZpJcOo/BK6XNEKGFU7+/
 Mb8XjIZ/XChKYyqx6mBHIHB4N5r+tdh2978551b/PkKQxaM41Q
 XggYAvUy/epLHlyhQVQLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 October 2010, Catalin Marinas wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> Now that phys_addr_t can be 64-bit on ARM, we must ensure that dma_addr_t
> is sufficiently large to hold physical addresses.
> 
> This patch uses the types.h implementation in asm-generic to define the
> dma_addr_t type as the same width as phys_addr_t.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

This patch will become obsolete once the "unify dma_addr_t typedef"
series from Fujita Tomonori is upstream, you will instead have to set
CONFIG_ARCH_DMA_ADDR_T_64BIT.

	Arnd

