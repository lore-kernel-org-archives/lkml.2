Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2HOOfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:35:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56410 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2HOOfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:35:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 22/31] arm64: Floating point and SIMD
Date: Wed, 15 Aug 2012 14:35:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-23-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-23-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151435.30646.arnd@arndb.de>
X-Provags-ID: V02:K0:Bx+T6179VCHoSE2on2xr3ztzOi2515gn3k7zBBNwYaZ
 mjB7c0BgmnVHURS/U/h5eSHeWDx4zeNH3PczkPCERG81Myrp2z
 rjJyHmKPIEw25pg1gff+qncJeeAToorlbSaf2AB7W3054Xax4I
 JkIlLeYXkeiqwqBqERykJU766S+aWfmpQ7DyaGHgSa9FYS7uhh
 6wgGaU+l0jDU7tKr3IwqEr1DE60sEwgrCiZedIvjFYKrrte0jq
 ntK044KK7sch1Evpy4lns/1QlH6dCx6HaBk2ASiUR5W2G7/uTH
 Cntgkia8z2KyWmg2IqlQTmsAZX9qFlCfMW/H5dXaUOu/vo1orI
 72B0Xc6Mug0k+7eYKX3U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> This patch adds support for FP/ASIMD register bank saving and restoring
> during context switch and FP exception handling to generate SIGFPE.
> There are 32 128-bit registers and the context switching is currently
> done non-lazily. Benchmarks on real hardware are required before
> implementing lazy FP state saving/restoring.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
