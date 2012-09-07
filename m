Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2IGTry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:47:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2IGTrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:47:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 21/31] arm64: 32-bit (compat) applications support
Date: Fri, 7 Sep 2012 19:47:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-22-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-22-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071947.45313.arnd@arndb.de>
X-Provags-ID: V02:K0:jr4/0NwvX2tivco6H/RHvx9xMZr+CImJydlNIdjOKRP
 8DUm7Fz5xeLHewbsLcaFvWDww93ISz1Ld45f+cvBDz5p/o9yOy
 nfDR/Ym+/maTA2G+qe4gg2Q6x5HP9RCwqT2LLR24fJoWWofiZm
 WvCHTWcTIWLL1XrLuTYbuiuTm44zf7msjMB+UTcfa2hTnC7Tcf
 gC8C+IJIdAADocYDYcaR2AL2E8G/EOfCgEhTK4zjNSQw3iQgDa
 ybzGsT+u1AXC/GsHAfEIgCag3+yhYohTb4BAKVfwqNsoR9rDwO
 SWpfO7IbLViSBXS3PImyYVy9tHU+LcixaDOztH46XJuybMl4+2
 6mvG284W73/r0barBUWw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> 
> From: Will Deacon <will.deacon@arm.com>
> 
> This patch adds support for 32-bit applications. The vectors page is a
> binary blob mapped into the application user space at 0xffff0000 (the
> AArch64 toolchain does not support compilation of AArch32 code). Full
> compatibility with ARMv7 user space is supported. The use of deprecated
> ARMv7 functionality (SWP, CP15 barriers) has been disabled by default on
> AArch64 kernels and unaligned LDM/STM is not supported.
> 
> Please note that only the ARM 32-bit EABI is supported, so no OABI
> compatibility.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

I guess you haven't had time to turn any of these into architecture
independent functions as discussed last time?

	Arnd
