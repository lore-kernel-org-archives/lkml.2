Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab2IJNv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:51:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab2IJNv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:51:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 17/31] arm64: System calls handling
Date: Mon, 10 Sep 2012 13:51:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <201209071943.37184.arnd@arndb.de> <20120910095619.GA27042@arm.com>
In-Reply-To: <20120910095619.GA27042@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209101351.52902.arnd@arndb.de>
X-Provags-ID: V02:K0:0+9ywwCJjcFu/ONCs8ZI3AeyjUcM/YBxA4dzvabC6oR
 BwEIsG5SnzsiLHvRGh/SBEmkpnbSSUJsu1yZnMOHFyWThu2AR4
 EfYPR2c/r7LvvJQtFO2H6UKtu0Q9rTC91SSlzUedeFeDAyUL92
 dTzZiyFxB97f5hloDNcNM+4zcdo2fYxSPZBaECk4OnHmSvAYWs
 7ypOMYXGCEW37FAyr1VvW+2I9XHgOFq8+Mq7c8slGLPeTdaoyf
 jBqPNcYwerPaIzrT8fvzRnmh1hjLaEZEea4KVlKBHiBOPSgjGl
 8eKUaSN+XE8ahHI0ifNW1iqIhrYxOrZTfJ0GvlXBLPH2QEXvb/
 xKVOZh8pEIyT0F1BfTCc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2012, Catalin Marinas wrote:
> Yes, I've seen these but since Al's patches are not in mainline, I don't
> want to add additional dependencies to the arm64 patches (currently
> based on 3.6-rc4). Once they get into mainline, I'll add a patch that
> converts arm64 to the generic functions above.
> 
> For kernel_execve(), I think I can simplify it further and not rely on
> Al's patches (similar to other architectures doing an SVC from kernel):

Hmm, I thought one of the reasons for Al to do his series was to discourage
people from doing syscalls from kernel space, but I may be misremembering
things. Al?

	Arnd
