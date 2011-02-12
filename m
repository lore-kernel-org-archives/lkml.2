Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1BLJ4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 04:56:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52164 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BLJ41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 04:56:27 -0500
Date: Sat, 12 Feb 2011 09:56:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/19] ARM: LPAE: Fix early_pte_alloc() assumption
	about the Linux PTE
Message-ID: <20110212095617.GA15616@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-3-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295891761-18366-3-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 05:55:44PM +0000, Catalin Marinas wrote:
> With LPAE we no longer have software bits in a separate Linux PTE and
> the early_pte_alloc() function should pass PTE_HWTABLE_OFF +
> PTE_HWTABLE_SIZE to early_alloc() to avoid allocating extra memory.

This one can also go to the patch system too.
