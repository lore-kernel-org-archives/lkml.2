Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab0LPPwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:52:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab0LPPwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:52:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH V7 2/8] posix clocks: introduce a syscall for clock tuning.
Date: Thu, 16 Dec 2010 16:51:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
References: <cover.1292512461.git.richard.cochran@omicron.at> <a93ce18c2987f7e102bc2ff5b12130211c222ea7.1292512461.git.richard.cochran@omicron.at>
In-Reply-To: <a93ce18c2987f7e102bc2ff5b12130211c222ea7.1292512461.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012161651.31748.arnd@arndb.de>
X-Provags-ID: V02:K0:vScenfOQRtgD6nusQFZcn/9eiHR/dv5n4oQuZw35z+U
 5u2Yzme4+ksmQC3MMLX80vMga8pig2Ss4nxxE/Vgsp5Q64zhMf
 AT4jBqh/+IZIXCpSKwuV7sCd3k3ztrDMXcCxchMbyuBgcZDaKq
 ywLRUQGjetY+eGzzKhN2tph3UWOEPCbU4t9+flsxY7q6Df63pn
 K1q9xeWm3VzJxIF1Nx60Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 December 2010, Richard Cochran wrote:
> A new syscall is introduced that allows tuning of a POSIX clock. The
> syscall is implemented for four architectures: arm, blackfin, powerpc,
> and x86.
> 
> The new syscall, clock_adjtime, takes two parameters, the clock ID,
> and a pointer to a struct timex. Any ADJTIMEX(2) operation may be
> requested via this system call, but various POSIX clocks may or may
> not support tuning.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>

The syscall implementation looks good to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>

It would be good to add it to include/asm-generic/unistd.h
as well, so that tile and future architectures get it, too.
