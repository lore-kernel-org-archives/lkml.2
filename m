Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1BOObQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:31:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52925 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1BOObM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:31:12 -0500
Date: Tue, 15 Feb 2011 14:23:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/19] ARM: LPAE: use phys_addr_t instead of
	unsigned long for physical addresses
Message-ID: <20110215142339.GL4152@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-16-git-send-email-catalin.marinas@arm.com> <20110212102803.GC15616@n2100.arm.linux.org.uk> <1297770742.21448.2.camel@e102144-lin.cambridge.arm.com> <20110215123522.GH4152@n2100.arm.linux.org.uk> <1297773569.14691.36.camel@e102109-lin.cambridge.arm.com> <1297777027.1293.2.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297777027.1293.2.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 01:37:07PM +0000, Will Deacon wrote:
> I should've spotted this either way. I've superseded the old patch with
> 6674/1.

One additional thing that I think has been lost.  I said in the original
reply to Catalin:
| asm/memory.h will conflict non-trivially with p2v patch set, but I think
| we can merge the changes to everything but __virt_to_phys/__phys_to_virt.

So 6670/1 which I'm intending to apply to the p2v branch can't be merged
as-is.  The ideal solution would be a version of 6670/1 to apply on top
of the existing p2v branch.

Thanks.
