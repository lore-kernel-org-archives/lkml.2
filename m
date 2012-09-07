Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab2IGXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 19:25:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58570 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab2IGXZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 19:25:25 -0400
Date: Fri, 7 Sep 2012 16:25:37 -0700
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 00/31] AArch64 Linux kernel port
Message-ID: <20120907232537.GA5098@quad.lixom.net>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 05:26:35PM +0100, Catalin Marinas wrote:
> This is the 3rd version of patches implementing Linux kernel support for
> the 64-bit ARM architecture. Most of the review comments for the
> previous release have been implemented. There are a few left (like
> generic timer dts specification) but the main goal was to freeze the
> user ABI.
> 
> The Linux kernel patches are available on this tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git upstream
> 
> Main changes since the previous version:
> - ptrace interface now using regsets for TLS and hardware debug
>   registers.
> - sys_personality fixes. PER_LINUX is the default for all tasks (32 or
>   64-bit) and there is no compat_sys_personality defined.
> - Kconfig clean-up (unused symbols, AARCH32_EMULATION removed in favour
>   of COMPAT).
> - Clean-up of the __cpuc_* function prefixes.
> - CPU information table implemented in C rather than assembly.
> - __bad_* function calls replaced with BUILD_BUG.
> - Inline get_user/put_user (code cleaner, slightly bigger kernel Image).
> - DMA API implementation simplified, defaulting to swiotlb. It will be
>   extended as hardware becomes available.
> - Arch-specific code in the generic timer patch moved to arch/arm64/.
> - Comment fixes and clarifications.

I see that a good amount of the comments I had on v2 have neither been replied
to nor addressed.

Please address them where appropriate, ideally before merging. I'll be happy to
be told I'm wrong in some of the cases too, but completely ignoring feedback
isn't cool.

However, most of them were nits, and I've had a look-through of the rest
of the patches, feel free to add:

Acked-by: Olof Johansson <olof@lixom.net>

on the patches in this series.

-Olof
