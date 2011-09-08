Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1IIAAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:00:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52959 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab1IIAAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:00:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH 17/62] powerpc: irq: Remove IRQF_DISABLED
Date: Thu, 8 Sep 2011 18:41:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Geoff Levand <geoff@infradead.org>,
        Milton Miller <miltonm@bga.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Meador Inge <meador_inge@mentor.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-18-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1315383059-3673-18-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109081841.28487.arnd@arndb.de>
X-Provags-ID: V02:K0:NSuiID5y6Zvw0rX7uWXq3YUX/Xpq2FgqEMHwkQToka5
 Q/VPKEkxk1MsmI0rlndpZNlsJf+GGSUeghlS8r0l5+mclZ3ba4
 kJo7Qhi4a83ermfGhmyHZOWRescahN6ckYzSJFbs3S+EnnOa3r
 gm1tofaWmIkap8odwJCOqmL1K8v05vWlk2n6CZiOOHK5feinxU
 N3dYBd3YYSX0+Sd0NO4PuJkXSsk1hq6ERmo6cQZOEwBzy2VJVB
 vKGHiLwgOYqqHlqOKWLeeqpG0DW0U53Rf0BpsX864VP/0KjLqE
 9JxxDfnM6OvsHiqRE//iqyf1oIEG+KC7LRh3BxqnwzfuWujS0l
 KMS6cPUAkmrBLF1+X7YM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 September 2011, Yong Zhang wrote:
> 
> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  arch/powerpc/include/asm/floppy.h              |    4 ++--
>  arch/powerpc/include/asm/xics.h                |    4 ++--
>  arch/powerpc/kernel/smp.c                      |    2 +-
>  arch/powerpc/platforms/cell/beat.c             |    2 +-
>  arch/powerpc/platforms/cell/celleb_scc_pciex.c |    2 +-
>  arch/powerpc/platforms/cell/iommu.c            |    3 +--
>  arch/powerpc/platforms/cell/pmu.c              |    2 +-
>  arch/powerpc/platforms/cell/spu_base.c         |    9 +++------

Acked-by: Arnd Bergmann <arnd@arndb.de>
