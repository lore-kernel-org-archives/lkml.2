Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2D3OWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 10:22:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62969 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab2D3OWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 10:22:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH] ARM: kirkwood: add missing kexec.h include
Date: Mon, 30 Apr 2012 14:21:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Sergei Shtylyov <sshtylyov@mvista.com>
References: <1335706842-11725-1-git-send-email-ijc@hellion.org.uk>
In-Reply-To: <1335706842-11725-1-git-send-email-ijc@hellion.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204301421.45446.arnd@arndb.de>
X-Provags-ID: V02:K0:HFQPlhOZwh40Ls672Cta0vXPrCwzY9Dn1jOjTPpsvrI
 xEbMvvHLcMfJqXbVc14w+hiClN+fVY8JYEveU70AOXx8HIFI94
 uuvbxzN6lpU+5YLK21XRPYpEKhxjUNGlXmVcHNaGMQay4wB4rv
 u0Q/RmWFE2detArTjpEmrGsL6QyzhsFTltKcZjaLPr6sdlgN1b
 W9xSKkQixIKDJw1NM99nbwn8mxVa4nQTJVEqNHsXUaHA4AFhDi
 aTf4d6RMntj/+AHuzIAMzwlLfO3XF2USoYPvSHryxP79oUcC+f
 wW8sdrjXr0coPeIUyp9LX3YWLDp+6/3phLaJsNXTr9J1I9eDjO
 7lSroDWRVOab3qUvK/+c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 April 2012, Ian Campbell wrote:
> 
> Fixes the following build error when CONFIG_KEXEC is enabled:
>   CC      arch/arm/mach-kirkwood/board-dt.o
> arch/arm/mach-kirkwood/board-dt.c: In function 'kirkwood_dt_init':
> arch/arm/mach-kirkwood/board-dt.c:52:2: error: 'kexec_reinit' undeclared (first use in this function)
> arch/arm/mach-kirkwood/board-dt.c:52:2: note: each undeclared identifier is reported only once for each function it appears in
> 
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> [v4, rebase onto recent Linus for repost]
> [v3, speak actual English in the commit message, thanks Sergei Shtylyov]
> [v2, using linux/kexec.h not asm/kexec.h]

Acked-by: Arnd Bergmann <arnd@arndb.de>

Jason, can you apply this patch on your tree?

	Arnd
