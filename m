Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0EaN4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:56:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:48900 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754462Ab0EaN4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:56:06 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/P8kJbjxzP3g4e0Zd2DStgJMbcizv8N4N5MegLCt
	ZXtP+wVE3h7aVg
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Borislav Petkov <bp@alien8.de>, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
Date: Mon, 31 May 2010 15:55:53 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.3; i686; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <201005271944.09541.toralf.foerster@gmx.de> <20100530193956.GA2498@liondog.tnic> <20100530201738.GB2498@liondog.tnic>
In-Reply-To: <20100530201738.GB2498@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201005311555.56791.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Borislav Petkov wrote at 22:17:38
> LKML-Reference: <201005271944.09541.toralf.foerster@gmx.de>
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  arch/um/include/asm/arch_hweight.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>  create mode 100644 arch/um/include/asm/arch_hweight.h
> 
> diff --git a/arch/um/include/asm/arch_hweight.h b/arch/um/include/asm/arch_hweight.h
> new file mode 100644
> index 0000000..c656cf4
> --- /dev/null
> +++ b/arch/um/include/asm/arch_hweight.h
> @@ -0,0 +1,6 @@
> +#ifndef _ASM_UM_HWEIGHT_H
> +#define _ASM_UM_HWEIGHT_H
> +
> +#include <asm-generic/bitops/arch_hweight.h>
> +
> +#endif
> 
This patch does not to solve the reported issue by me.

-- 
MfG/Sincerely
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

