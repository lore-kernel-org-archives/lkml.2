Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1B0Xn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 18:43:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53690 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1B0Xny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 18:43:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCHv2 06/11] unicore32 core architecture: mm related: generic codes
Date: Sun, 27 Feb 2011 18:12:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <02ed01cbcb48$3e3781a0$baa684e0$@mprc.pku.edu.cn> <201102221618.56779.arnd@arndb.de> <018101cbd639$3c639430$b52abc90$@mprc.pku.edu.cn>
In-Reply-To: <018101cbd639$3c639430$b52abc90$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102271812.29526.arnd@arndb.de>
X-Provags-ID: V02:K0:mqanoKKWqOzLBeTKFeaWbaurQBMq8pSW0bUkjzQEfi7
 zKCFjlyg9jT5a6N0ZZGnm+4eJm8twuUaIhyuPHR+gVp0LCf/qY
 Rg2XTqMIJitC8FLlDQ5TkliNDyIB0ZslSjJV0b1e+WlQPcQ/X9
 fdQHaiIpXrQ+g5UHRIe63nej01EafIsTa5OOlKlVcxpLdTNJAp
 Fs6Ct5d3wRByqzJ/OW3LA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 February 2011, Guan Xuetao wrote:
> From: GuanXuetao <gxt@mprc.pku.edu.cn>
> Date: Sun, 27 Feb 2011 12:46:06 +0800
> Subject: [PATCH] unicore32: replace unicore32-specific iomap functions with generic lib implementation
> 
> 1. define and enable CONFIG_GENERIC_IOMAP
> 2. define unicore32-specific PCI_IOBASE for asm-generic/io.h
> 3. define HAVE_ARCH_PIO_SIZE and unicore32-specific PIO_* macros
> 4. remove all unicore32-specific iomap functions
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Excellent!

Acked-by: Arnd Bergmann <arnd@arndb.de>

