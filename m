Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2HGLcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:32:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56148 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2HGLct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:32:49 -0400
Date: Tue, 7 Aug 2012 12:32:30 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807113230.GE24257@flint.arm.linux.org.uk>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com> <1344327742.2698.15.camel@pasglop> <20120807082813.GB24257@flint.arm.linux.org.uk> <201208071128.27616.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208071128.27616.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 11:28:27AM +0000, Arnd Bergmann wrote:
> If we introduce a new IORESOURCE_OTHER, I would actually prefer to
> define it to 0x00000000 for purely aesthetic reasons, the effect
> should be the same as using 0x00000300.

I'd suggest not, because we can use that to detect uninitialized
resources (and we probably do so in some places.)  IOW, I think that's
asking for problems when this moves outside platform code.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
