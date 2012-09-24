Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2IXNiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:38:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38833 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2IXNix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:38:53 -0400
Date: Mon, 24 Sep 2012 14:38:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, davidb@codeaurora.org,
        frank.rowand@am.sony.com, hsweeten@visionengravers.com,
        linus.walleij@linaro.org, marc.zyngier@arm.com, nico@linaro.org,
        paul.gortmaker@windriver.com, plagnioj@jcrosoft.com, rabin@rab.in,
        rmallon@gmail.com, rob.herring@calxeda.com, sboyd@codeaurora.org,
        sjg@chromium.org, tglx@linutronix.de, tj@kernel.org,
        vincent.guittot@linaro.org, vitalya@ti.com, will.deacon@arm.com,
        grant.likely@secretlab.ca
Subject: Re: [PATCH v3 RESEND 09/17] ARM: LPAE: use phys_addr_t for initrd
	location and size
Message-ID: <20120924133826.GA26454@n2100.arm.linux.org.uk>
References: <1348242975-19184-1-git-send-email-cyril@ti.com> <1348242975-19184-10-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348242975-19184-10-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:56:07AM -0400, Cyril Chemparathy wrote:
> From: Vitaly Andrianov <vitalya@ti.com>
> 
> This patch fixes the initrd setup code to use phys_addr_t instead of assuming
> 32-bit addressing.  Without this we cannot boot on systems where initrd is
> located above the 4G physical address limit.

The description needs updating.  You're no longer using phys_addr_t for the
initrd size.
