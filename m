Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1BOMfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:35:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33189 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1BOMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:35:36 -0500
Date: Tue, 15 Feb 2011 12:35:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/19] ARM: LPAE: use phys_addr_t instead of
	unsigned long for physical addresses
Message-ID: <20110215123522.GH4152@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-16-git-send-email-catalin.marinas@arm.com> <20110212102803.GC15616@n2100.arm.linux.org.uk> <1297770742.21448.2.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297770742.21448.2.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 11:52:22AM +0000, Will Deacon wrote:
> Excellent! I've split the patch up into four distinct parts, as per your
> suggestions. I've submitted these to your patch system (6670/1-6673/1)
> alongside a fixed version of the printf format patch (6669/1) because
> without that, you get a bunch of compiler warnings.

Except 6669/1 still suffers from "%#08llx".  For a value of one, that prints:

	0x000001

five zeros following the 0x rather than seven.  The width in the format
string includes the 0x prefix.
