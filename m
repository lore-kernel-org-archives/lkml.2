Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab2IGTkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:40:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2IGTka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:40:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 16/31] arm64: ELF definitions
Date: Fri, 7 Sep 2012 19:40:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-17-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-17-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071940.25377.arnd@arndb.de>
X-Provags-ID: V02:K0:ej3TkJQNRueS9LTdxCD0maf97Cj8cJlkR2qpXW9kC53
 61mlN5TjwtA3vpBw5VZoDalg8bobssI9lslDVsnv4UBAqaIRlu
 RcmvkKO1B8hHOmohpClLlMLwDaEDeIlkri05NjT0oMjrvra7Ob
 4ePIypQF2cySv2sj6fthAow9qy32UfF2P0ulajBRGFiOCQylAe
 F+b30sMOB8aYWfViAgZLCG+yrEMEtp+0p92k3iMoRHICv3eDn7
 CZczQXiBNvTnnAYbUUeraMWbkE/AFzg4RYvdxqFj9g0dnSpru1
 BVUrkdrbSoC+sZMiuFWxKZUCi5RLOJwVmIT4jh4KJGlaTL+/Ib
 BJIz7yaFjMGYEXuJuYdM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> This patch adds definitions for the ELF format, including personality
> personality setting and EXEC_PAGESIZE. The are only two hwcap
> definitions for 64-bit applications - HWCAP_FP and HWCAP_ASIMD.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
