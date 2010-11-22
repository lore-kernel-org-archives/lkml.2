Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0KVNnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:43:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40072 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab0KVNnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:43:43 -0500
Date: Mon, 22 Nov 2010 13:43:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 19/20] ARM: LPAE: define printk format for physical
	addresses and page table entries
Message-ID: <20101122134325.GK31227@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-20-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289584840-18097-20-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 06:00:39PM +0000, Catalin Marinas wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> Now that the Kernel supports 2 level and 3 level page tables, physical
> addresses (and also page table entries) may be 32 or 64-bits depending
> upon the configuration.
> 
> This patch adds a conversion specifier (PHYS_ADDR_FMT) which represents
> a u32 or u64 depending on the width of a physical address.

I hope this patch is gone in v3.
