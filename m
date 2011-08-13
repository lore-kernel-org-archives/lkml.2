Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1HMOec (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:34:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55666 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab1HMOea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:34:30 -0400
Date: Sat, 13 Aug 2011 15:34:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 03/16] ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead
	of PGDIR_*
Message-ID: <20110813143423.GP4775@n2100.arm.linux.org.uk>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com> <1312988619-16804-4-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312988619-16804-4-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:03:26PM +0100, Catalin Marinas wrote:
> PGDIR_SHIFT and PMD_SHIFT for the classic 2-level page table format have
> the same value (21). This patch converts the PGDIR_* uses in the kernel
> to the PMD_* equivalent so that LPAE builds can reuse the same code.

Ok.
