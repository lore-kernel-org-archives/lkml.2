Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1AXXie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:38:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44855 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab1AXXic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:38:32 -0500
Date: Mon, 24 Jan 2011 23:38:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 01/19] ARM: Make the argument to virt_to_phys()
	"const volatile"
Message-ID: <20110124233801.GT24104@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-2-git-send-email-catalin.marinas@arm.com> <4D3DD0D8.10905@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3DD0D8.10905@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:19:52AM -0800, Stephen Boyd wrote:
> On 01/24/2011 09:55 AM, Catalin Marinas wrote:
> > Changing the virt_to_phys() argument to "const volatile void *" avoids
> > compiler warnings in some situations where this function is used.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Stephen Boyd <sboyd@codeaurora.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > ---
> 
> Acked-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Any chance we can get this one patch into 2.6.38? It fixes a warning for
> MSM.

I don't see any reason why this can't.  Catalin, can you put it in the
patch system with Stephen's ack please?
