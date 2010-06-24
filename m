Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0FXJF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:05:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42331 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab0FXJF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:05:28 -0400
Date: Thu, 24 Jun 2010 10:05:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: module - simplify unwind table handling
Message-ID: <20100624090502.GA1398@n2100.arm.linux.org.uk>
References: <1275567442-11370-1-git-send-email-ext-phil.2.carmody@nokia.com> <1275567442-11370-2-git-send-email-ext-phil.2.carmody@nokia.com> <1275567442-11370-3-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275567442-11370-3-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 03:17:21PM +0300, Phil Carmody wrote:
>  #ifdef CONFIG_ARM_UNWIND
...
> +#else
> +struct mod_arch_specific {
> +}
> +#endif

I assume no one tried building these with UNWIND disabled?  linux-next
reports most ARM builds are broken by this.

Dropped all three patches out of my git tree until it can be fixed.
