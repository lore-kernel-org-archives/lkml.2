Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab0GMXOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 19:14:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1396 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab0GMXOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 19:14:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6042"; a="47234484"
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for
 defconfig
From: Daniel Walker <dwalker@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <20100713230352.6781.18644.stgit@angua>
References: <20100713230352.6781.18644.stgit@angua>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 16:14:41 -0700
Message-ID: <1279062881.4609.34.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-13 at 17:04 -0600, Grant Likely wrote:

> - I haven't figured out a way for the fragment to force an option to
>   be "n", or to set a value, for example "CONFIG_LOG_BUF_SHIFT=16".
>   This may require changing the syntax.
> - It still doesn't resolve dependencies.  A solver would help with this.
>   For the time being I work around the problem by running the generated
>   config through 'oldconfig' and looking for differences.  If the files
>   differ (ignoring comments and generateconfig_* options) after oldconfig,
>   then the <board>_defconfig target returns a failure.  (but leaves the
>   new .config intact so the user can resolve it with menuconfig).  This
>   way at least the user is told when a Kconfig fragment is invalid.

The solver would fix the whole issues with the defconfigs , we wouldn't
need this Kconfig change .. From my perspective we shouldn't be fooling
around with anything but the solver approach ..

It just doesn't feel like Kconfig was meant to do this, it feel like
somewhat of an abuse ..

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

