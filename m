Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab2IGTjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:39:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2IGTju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:39:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 15/31] arm64: SMP support
Date: Fri, 7 Sep 2012 19:39:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-16-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-16-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071939.45799.arnd@arndb.de>
X-Provags-ID: V02:K0:6OIe/8A308X+gVIytuj3NsLxYDsCyJobksqEXjwp1pN
 AyUcbYhs0jkAv3ddgTFtJ2s3U7B64Em/s4Q/guKddV1mh6uHJg
 LpyXWjW8VfwEykNntAYQmMPoLMwzzrqiGkr2r3854bKIbYLXy/
 U1ADf4mpnta4v+bIseSRHOTdHa2EfGUHExK3JvDk4fJ2Ie1jnv
 NhfXuqzM++2Q3Tp37fZOxw2llXZxLXaPair3cvmGOTwDYyokLn
 CEma9md9yFWz9Mw/ZFy7TnhCCvMXGbagH+6BQWEmFiTIunbAjE
 hHSY8a+1G+73cKxEn8VADzCAVtWNA6cCEolvnGvAir4U63Kf/5
 g6FSbkgpze89u3Fl0nEY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> This patch adds SMP initialisation and spinlocks implementation for
> AArch64. The spinlock support uses the new load-acquire/store-release
> instructions to avoid explicit barriers. The architecture also specifies
> that an event is automatically generated when clearing the exclusive
> monitor state to wake up processors in WFE, so there is no need for an
> explicit DSB/SEV instruction sequence. The SEVL instruction is used to
> set the exclusive monitor locally as there is no conditional WFE and a
> branch is more expensive.
> 
> For the SMP booting protocol, see Documentation/arm64/booting.txt.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
