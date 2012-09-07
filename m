Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2IGTJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:09:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52406 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IGTJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:09:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 03/31] arm64: Exception handling
Date: Fri, 7 Sep 2012 19:09:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-4-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-4-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071909.30852.arnd@arndb.de>
X-Provags-ID: V02:K0:l73jPVQvnQbEu3/PFXR5OVLHKsT9h3A0UToGqQC2VvQ
 RNdNNyEq64xBetYnFSMjNKRfvHZYOxwjtnjJ/0Ih4+48W4dc8p
 e1uk1Sl+Gw+YTxrkua2SroGc+pLUeqlug+bM82QhpwII0KI7sB
 nSIHPvwdmtj5p3pl0kulXdlbB+kTiQeXpm9ARGY64IV5OBCbGb
 IWKTN2BUGdKRjEfKm4kz964JfqA6dIzifUoFw7aJAcY48jLNLZ
 6H7US21+o00pr4yEdUgyRLw8XkLcuxfeQ55Who+XHDdjC7H12Z
 xPREdP0EuBq+51mrThTtzohn7xb3L6sMpTB6u19tcQF0fUnUOR
 mmoHQ0bKVmvG33lCFOls=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> The patch contains the exception entry code (kernel/entry.S), pt_regs
> structure and related accessors, undefined instruction trapping and
> stack tracing.
> 
> AArch64 Linux kernel (including kernel threads) runs in EL1 mode using
> the SP1 stack. The vectors don't have a fixed address, only alignment
> (2^11) requirements.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
