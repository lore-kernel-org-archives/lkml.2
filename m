Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1EWQyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:54:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59278 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab1EWQyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:54:32 -0400
Date: Mon, 23 May 2011 17:54:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/19] ARM: Add support for the Large Physical
	Address Extensions
Message-ID: <20110523165412.GF15138@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 01:51:19PM +0100, Catalin Marinas wrote:
> This set of patches adds support for the Large Physical Extensions on
> the ARM architecture (available with the Cortex-A15 processor). LPAE
> comes with a 3-level page table format (compared to 2-level for the
> classic one), allowing up to 40-bit physical address space.
> 
> The ARM LPAE documentation is available from (free registration needed):
> 
> http://infocenter.arm.com/help/topic/com.arm.doc.ddi0406b_virtualization_extns/index.html
> 
> The full set of patches on top of linux-next (LPAE, support for an
> emulated Versatile Express with Cortex-A15 tile and generic timers) is
> available on this branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-2.6-cm.git arm-lpae-next

FYI, I'm going to drop the pgt patch because the warnings are still there
and I _still_ don't feel happy about pushing that into mainline and then
being endlessly bugged about it.

So I'll drop it from my tree again and re-merge that branch after this
window has closed.
