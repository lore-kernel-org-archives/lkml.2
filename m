Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1GLNaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 09:30:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65123 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1GLNaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 09:30:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?iso-8859-15?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] new helper to define common struct resource constructs
Date: Tue, 12 Jul 2011 15:29:17 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>, thierry.nolf.barco@gmail.com,
        Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Lothar =?iso-8859-15?q?Wa=DFmann?= <LW@karo-electronics.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <14C4E31473AF7E4B98176CB73615181C19FBD3@039-SN1MPN1-006.039d.mgd.msft.net> <201107072304.05626.arnd@arndb.de> <E1QgHeh-0004k8-2m@octopus.hi.pengutronix.de>
In-Reply-To: <E1QgHeh-0004k8-2m@octopus.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Message-Id: <201107121529.17611.arnd@arndb.de>
X-Provags-ID: V02:K0:6ythQqasGZhpJY7Yt2xFOcnTXPpP06xJ2CzZSs6cGZi
 idTsG2e1oTjgmwyJl6jF4GBLH4dV8mplgQn3XmINYZwY4Kh9qi
 9OOrdYxbkmXMJ4pMJusf7P8aqHsLuFYZLrSb12HrO0WzvdRJVL
 y8Cl24JeorC1o8ewnGlMaAMNmgjx6qg4SX8xgU5ktjNqgF/9Ew
 SwL4w8CCJiE6u7xvVLkew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 July 2011, Uwe Kleine-König wrote:
> resource definitions that just define start, end and flags = IORESOURCE_MEM
> or IORESOURCE_IRQ (with start=end) are quite common. So introduce a shortcut
> for them. Also make available a macro to specify named resources of both
> types which are less common.
> 
> Signed-off-by: Uwe Kleine-KÃ¶nig <u.kleine-koenig@pengutronix.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

What do others think, is this worthwhile?
Should we also define macros for IORESOURCE_IO and IORESOURCE_DMA?

	Arnd
