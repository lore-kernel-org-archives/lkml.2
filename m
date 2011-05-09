Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab1EIQJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:09:16 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:37650
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659Ab1EIQJP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:09:15 -0400
X-SpamScore: -16
X-BigFish: VS-16(zz9371O1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc/mpc8610_hpcd: Do not use "/" in interrupt names
Thread-Topic: [PATCH] powerpc/mpc8610_hpcd: Do not use "/" in interrupt names
Thread-Index: AQHMDmNuKpMWZdItIEWhmorYcx2eig==
Date: Mon, 9 May 2011 16:09:10 +0000
Message-ID: <BANLkTi=ytcPhpYp=Mqk7fYYAv+5eqbkNww@mail.gmail.com>
References: <alpine.DEB.2.00.1105041627560.2601@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1105041627560.2601@ayla.of.borg>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.56.112.32]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <55E5303434DEDE44999A9E3AC5E41CC9@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 9:29 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> It may trigger a warning in fs/proc/generic.c:__xlate_proc_name() when
> trying to add an entry for the interrupt handler to sysfs.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Timur Tabi <timur@freescale.com>

This fixes a real bug in the kernel.

-- 
Timur Tabi
Linux kernel developer at Freescale
