Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0KVNMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:12:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43030 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab0KVNMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:12:14 -0500
Date: Mon, 22 Nov 2010 13:11:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/20] ARM: LPAE: Remove the FIRST_USER_PGD_NR and
	USER_PTRS_PER_PGD definitions
Message-ID: <20101122131153.GF31227@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-11-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289584840-18097-11-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 06:00:30PM +0000, Catalin Marinas wrote:
> These macros were only used in setup_mm_for_reboot and get_pgd_slow.
> Both have been modified to no longer use these definitions. One of the
> reasons is the different meaning that PGD has with the 2-level and
> 3-level page tables.

We don't actually need this macro anymore, it can be killed (and I've
already done so.)
