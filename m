Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1HST5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:57:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38995 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab1HST5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:57:04 -0400
Date: Fri, 19 Aug 2011 20:56:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, khilman@ti.com,
        Ranjith Lohithakshan <ranjithl@ti.com>
Subject: Re: [PATCH 1/4] AM3517 : support for suspend/resume
Message-ID: <20110819195649.GB18947@n2100.arm.linux.org.uk>
References: <1313754927-11992-1-git-send-email-abhilash.kv@ti.com> <1313754927-11992-2-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313754927-11992-2-git-send-email-abhilash.kv@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 05:25:24PM +0530, Abhilash K V wrote:
> 1. Patch to disable dynamic sleep (as it is not supported
>    on AM35xx).
> 2. Imported the unique suspend/resume sequence for AM3517,
>    contained in the new file arch/arm/mach-omap2/sleep3517.S.
> 3. Added omap3517_ to symbol-names in sleep3517.S which are common
>    with sleep34xx.S, and added appropriate checks.

You don't say what kernel these are against, it looks like it is not the
latest mainline kernel, as I cleaned up OMAP3 suspend/resume significantly
recently.  I think you need to update these patches against the latest
kernel and repost them.
