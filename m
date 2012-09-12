Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab2ILOyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:54:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39334 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759635Ab2ILOyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:54:50 -0400
Date: Wed, 12 Sep 2012 15:54:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 00/31] AArch64 Linux kernel port
Message-ID: <20120912145400.GJ21823@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <20120907232537.GA5098@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907232537.GA5098@quad.lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 12:25:37AM +0100, Olof Johansson wrote:
> On Fri, Sep 07, 2012 at 05:26:35PM +0100, Catalin Marinas wrote:
> > This is the 3rd version of patches implementing Linux kernel support for
> > the 64-bit ARM architecture. Most of the review comments for the
> > previous release have been implemented. There are a few left (like
> > generic timer dts specification) but the main goal was to freeze the
> > user ABI.
> > 
> > The Linux kernel patches are available on this tree:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git upstream
> > 
> > Main changes since the previous version:
> > - ptrace interface now using regsets for TLS and hardware debug
> >   registers.
> > - sys_personality fixes. PER_LINUX is the default for all tasks (32 or
> >   64-bit) and there is no compat_sys_personality defined.
> > - Kconfig clean-up (unused symbols, AARCH32_EMULATION removed in favour
> >   of COMPAT).
> > - Clean-up of the __cpuc_* function prefixes.
> > - CPU information table implemented in C rather than assembly.
> > - __bad_* function calls replaced with BUILD_BUG.
> > - Inline get_user/put_user (code cleaner, slightly bigger kernel Image).
> > - DMA API implementation simplified, defaulting to swiotlb. It will be
> >   extended as hardware becomes available.
> > - Arch-specific code in the generic timer patch moved to arch/arm64/.
> > - Comment fixes and clarifications.
> 
> I see that a good amount of the comments I had on v2 have neither been replied
> to nor addressed.

Sorry, as I said above, my main focus was get the user ABI sorted out as
a code is public and there are people that started using it. There are
still a few emails marked as "unread" in my inbox that need to be
addressed but I did not consider them critical for version 3 of the
series. They are not forgotten, however, I'm working back through those
emails and either reply or implement the suggestions.

> Acked-by: Olof Johansson <olof@lixom.net>

Thanks.

-- 
Catalin
