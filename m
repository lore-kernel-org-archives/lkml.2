Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0KVNQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:16:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59140 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0KVNQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:16:00 -0500
Date: Mon, 22 Nov 2010 13:15:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/20] ARM: LPAE: Add fault handling support
Message-ID: <20101122131546.GG31227@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-12-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289584840-18097-12-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 06:00:31PM +0000, Catalin Marinas wrote:
> @@ -108,7 +113,9 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
>  
>  		pte = pte_offset_map(pmd, addr);
>  		printk(", *pte=%08lx", pte_val(*pte));
> +#ifndef CONFIG_ARM_LPAE
>  		printk(", *ppte=%08lx", pte_val(pte[-LINUX_PTE_OFFSET]));
> +#endif

This is an unrelated change - should it be in a different patch?
