Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab1GTX2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 19:28:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49784 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1GTX2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 19:28:34 -0400
Date: Thu, 21 Jul 2011 00:28:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] ARM: Migrate to asm-generic wrapper support
Message-ID: <20110720232819.GC20310@n2100.arm.linux.org.uk>
References: <1311204225-13169-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311204225-13169-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 04:23:45PM -0700, Stephen Boyd wrote:
> With d8ecc5c (kbuild: asm-generic support, 2011-04-27) we can
> remove a handful of asm-generic wrappers in ARM code.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Imre Kaloz <kaloz@openwrt.org>
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> ---
> 
> I've specifically left out topology.h as it looks like that will not
> be generic much longer.

You don't mention in the commit log about the change to SZ_48M.
