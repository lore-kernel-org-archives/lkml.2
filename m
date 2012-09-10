Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab2IJRxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:53:32 -0400
Received: from relais.videotron.ca ([24.201.245.36]:55413 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab2IJRxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:53:30 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Mon, 10 Sep 2012 13:53:30 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 00/31] AArch64 Linux kernel port
In-reply-to: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
Message-id: <alpine.LFD.2.02.1209101339270.28681@xanadu.home>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Sep 2012, Catalin Marinas wrote:

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

For those patches in this series I didn't comment on already:

Acked-by: Nicolas Pitre <nico@linaro.org>

Small nit: please s/nico@cam.org/nico@fluxnic.net/.


Nicolas
