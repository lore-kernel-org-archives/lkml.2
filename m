Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2IGTKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:10:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab2IGTKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:10:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 04/31] arm64: MMU definitions
Date: Fri, 7 Sep 2012 19:10:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-5-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-5-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071910.18527.arnd@arndb.de>
X-Provags-ID: V02:K0:c0w1L0uknMlerf7d2ISL3jTeEZvvvN5CjpPokCy4P4j
 vSH63GGQ7goNIW28fvApCf3W3EYsZdf8IOL4IMnw35bBqCpJKU
 WXMDyD8qfBPLkbuRjMN3MoAu5cQkN7Yox3ge+wnNfWVE3wt3Xz
 l3hH1r7FTF6p92qv9UH5FowbJ+oBGLbY+4kBDgJqLz5XhGUEhV
 JGaviMdfzPtmJZajvFJaYZAmENIaDgKDzL41PjVgl299F0NQyk
 aEogQwu89PjqSrligOWl9jdWQk9mS+9fpyOh612yHMtkI28XKj
 shazKLNp0NVkexitp7yPdBc/VN0FpO9edRQu3nPEZDhGpLm42m
 E3ELOudo7s4qyLHwA1wQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> 
> The virtual memory layout is described in
> Documentation/arm64/memory.txt. This patch adds the MMU definitions for
> the 4KB and 64KB translation table configurations. The SECTION_SIZE is
> 2MB with 4KB page and 512MB with 64KB page configuration.
> 
> PHYS_OFFSET is calculated at run-time and stored in a variable (no
> run-time code patching at this stage).
> 
> On the current implementation, both user and kernel address spaces are
> 512G (39-bit) each with a maximum of 256G for the RAM linear mapping.
> Linux uses 3 levels of translation tables with the 4K page configuration
> and 2 levels with the 64K configuration. Extending the memory space
> beyond 39-bit with the 4K pages or 42-bit with 64K pages requires an
> additional level of translation tables.
> 
> The SPARSEMEM configuration is global to all AArch64 platforms and
> allows for 1GB sections with SPARSEMEM_VMEMMAP enabled by default.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
