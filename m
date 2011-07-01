Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab1GAQWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:22:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48629 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab1GAQWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:22:40 -0400
Date: Fri, 1 Jul 2011 17:24:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v6 00/18] ARM: Add support for the Large Physical
 Address Extensions
Message-ID: <20110701162419.GA3990@1n450.cable.virginmedia.net>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Tue, May 24, 2011 at 10:39:06PM +0100, Catalin Marinas wrote:
> Catalin Marinas (14):
>   ARM: LPAE: Use long long printk format for displaying the pud
>   ARM: LPAE: Use unsigned long for __phys_to_virt and __virt_to_phys
>   ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*
>   ARM: LPAE: Factor out 2-level page table definitions into separate
>     files
>   ARM: LPAE: Add (pte|pmd|pgd|pgprot)val_t type definitions as u32
>   ARM: LPAE: Use a mask for physical addresses in page table entries
[...]
> Will Deacon (4):
>   ARM: LPAE: add ISBs around MMU enabling code
>   ARM: LPAE: Use generic dma_addr_t type definition

Since the core LPAE patches haven't got a proper review yet, would you
please consider merging some of the LPAE preparation patches during the
upcoming window? Above is a list that I think it's relatively trivial
(or we can have an even smaller set of patches, any progress would be
good).

Thanks.

-- 
Catalin
