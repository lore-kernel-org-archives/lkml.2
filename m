Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab2E2M3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:29:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47172 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2E2M3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:29:46 -0400
Date: Tue, 29 May 2012 13:29:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] CMA and ARM DMA-mapping updates for v3.5
Message-ID: <20120529122932.GA24623@n2100.arm.linux.org.uk>
References: <1337672417-10065-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337672417-10065-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I notice we have new warnings as a result of CMA being merged, though
thankfully they're just in Kconfig:

warning: (ARM) selects CMA which has unmet direct dependencies (HAVE_DMA_CONTIGUOUS && HAVE_MEMBLOCK && EXPERIMENTAL)

This seems totally weird: you're mandating that ARM must have CMA
selected, but it's an experimental feature?  So you're implying that
the entire ARM kernel becomes totally experimental for the next
release cycle?

I think this needs fixing.
