Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1GUR1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:27:43 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:34200 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1GUR1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:27:41 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Imre Kaloz <kaloz@openwrt.org>, Eric Miao <eric.y.miao@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Migrate to asm-generic wrapper support
References: <1311204225-13169-1-git-send-email-sboyd@codeaurora.org>
	<20110720232819.GC20310@n2100.arm.linux.org.uk>
	<4E27667D.9060200@codeaurora.org>
Date: Thu, 21 Jul 2011 21:27:23 +0200
In-Reply-To: <4E27667D.9060200@codeaurora.org> (Stephen Boyd's message of
	"Wed, 20 Jul 2011 16:36:29 -0700")
Message-ID: <m31uxje8o4.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> With d8ecc5c (kbuild: asm-generic support, 2011-04-27) we can
> remove a handful of asm-generic wrappers in ARM code. Since the
> generic version of sizes.h doesn't contain SZ_48M, we replace
> the 3 users of SZ_48M with the equivalent SZ_32M + SZ_16M.

Perhaps simply adding SZ_48M to the generic version is better. Can live
with either.
-- 
Krzysztof Halasa
