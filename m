Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1LLW6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:58:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52673 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1LLW6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:58:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] unicore32: standardize /proc/iomem "Kernel code" name
Date: Sat, 10 Dec 2011 10:28:41 +0100
Message-ID: <3153514.2zQXbXxlEQ@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <20111209211346.GA2639@outflux.net>
References: <20111209211346.GA2639@outflux.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3nxARUzThwbRG9aidsheZ3BA71TjBQudnbO0ToOMlBx
 OmETBaoDp1RJ1U21opYGC9abGDnRIerJQynrQOPGYn1RQZcPFh
 CiF3SYVnJA6RmUDktJx8xPAEP9hrDRTiZ7zXE7KZifoVDZY7ar
 hXgWv0fgh699d6qtLpqI4thJSrlP0qUl4zCuliQkIoXO3z/1ud
 CLcuk97sq+MKyqYQhXGdZqGnsiFCPoKw0EWwJuESt00RbfA01K
 QAkwqFsbV6NuN9AqWl8UA1p8ESB8ae/dHySF/tCaqRG4K9l3Lv
 6gmkCItCud6DEPon4SCgsoZFxEPHFX+5sotvmUJ56wQjxsTiuN
 7EPA5bhqgFiQq7mo5gh0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 December 2011 13:13:46 Kees Cook wrote:
> All other ports use "Kernel code" to identify the Kernel text segment
> in /proc/iomem. Change the ARM resources to do the same.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Your patch description says ARM, not unicore32. Otherwise looks ok to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>
