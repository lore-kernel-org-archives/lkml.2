Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab2BHLwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:52:00 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:46703 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756727Ab2BHLvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:51:47 -0500
X-AntiVirus: Checked by Dr.Web [version: 6.0.3.08040, engine: 6.0.300.01310, virus records: 2622417, updated:  8.02.2012]
Message-ID: <4F326186.8090300@ru.mvista.com>
Date: Wed, 08 Feb 2012 15:50:30 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: tony@atomide.com, Tero Kristo <t-kristo@ti.com>,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.3] OMAP4: PRM: fix build breakage when CONFIG_OF is
 not defined
References: <1328698752-18756-1-git-send-email-coelho@ti.com>
In-Reply-To: <1328698752-18756-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-02-2012 14:59, Luciano Coelho wrote:

> Since 3.3-rc1, prm44xx.c build breaks if CONFIG_OF is not set:

> arch/arm/mach-omap2/prm44xx.c:41: error: 'OMAP44XX_IRQ_PRCM' undeclared here (not in a function)
> make[1]: *** [arch/arm/mach-omap2/prm44xx.o] Error 1

> This is because of a missing include, which is added indirectly if
> CONFIG_OF is defined.  This problem was introduced in commit
> 2f31b51659c2d8315ea2888ba5b93076febe672b

    Please also specify the summary of that commit in parens.

> Cc: Tero Kristo<t-kristo@ti.com>
> Signed-off-by: Luciano Coelho<coelho@ti.com>

WBR, Sergei
