Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1A2JvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 04:51:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39086 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1A2JvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 04:51:12 -0500
Date: Sat, 29 Jan 2011 09:50:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch:arm:mbox-db5500.c Change initate to initiate.
Message-ID: <20110129095045.GA1842@n2100.arm.linux.org.uk>
References: <1296244040-3653-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296244040-3653-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 11:47:20AM -0800, Justin P. Mattock wrote:
> Not sure if this is a typo or not. if it is then feel free to take this.

You should copy the maintainers for this platform:

ARM/Ux500 ARM ARCHITECTURE
M:      Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
M:      Linus Walleij <linus.walleij@stericsson.com>
L:      linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
S:      Maintained
F:      arch/arm/mach-ux500/
F:      drivers/dma/ste_dma40*
F:      drivers/mfd/ab3550*
F:      drivers/mfd/abx500*
F:      drivers/mfd/ab8500*
F:      drivers/mfd/stmpe*
F:      drivers/rtc/rtc-ab8500.c
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git
