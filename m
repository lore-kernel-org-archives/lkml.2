Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab2JEUos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:44:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687Ab2JEUon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:44:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] sysctl: Fix 'defined but not used' warning
Date: Fri, 5 Oct 2012 18:03:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, festevam@gmail.com
References: <1349452668-8601-1-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1349452668-8601-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210051803.28848.arnd@arndb.de>
X-Provags-ID: V02:K0:5orh0PG8/A5uH417ElPTH8GkxS618rOPZqKebamFdY2
 JZ2HEgxpuQnq54aTl26YkGd3HS9VBlHzJXg3XwAmJ09CgnKA0d
 Lp1acrKG7z4oS+1RgtRNrxeDi3Uz/utUiRSiTaFdMeyqcjM//Q
 cKPfsXn7TTg4AvjrfQR2bhJlezHoW5mqzllzgFg34x+uORrXWx
 8OjpGP02pcSKIZ92amL36FC3TGqoO2Qo32zFzxMyM5sCw8Xwzb
 xrXlilTt3wWHbUTk+CzZp+loHCU7rGdmTqqDATZBQt7o+1n6zb
 R763BqmM5i15HEJhCB6wAouBqgHYZfIfDItIZTD8ZXFVeOtcp4
 D3lymt7nYT/64BSrac50=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2012, Fabio Estevam wrote:
> Since commit 4ae834f767(sched/numa: Implement NUMA home-node selection code)
> building a kernel with CONFIG_SMP disabled causes the following warning:
> 
> kernel/sysctl.c:259:12: warning: 'min_sched_tunable_scaling' defined but not used [-Wunused-variable]
> kernel/sysctl.c:260:12: warning: 'max_sched_tunable_scaling' defined but not used [-Wunused-variable]
> 
> Annotate theses variables as '__maybe_unused'.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I noticed the same thing and had a different fix for it, but yours is better anyway.
