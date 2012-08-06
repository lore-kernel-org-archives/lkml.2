Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab2HFOCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:02:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49947 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab2HFOC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:02:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 0/6] ARM: dove: DT support for Marvell Dove
Date: Mon, 6 Aug 2012 14:02:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>
References: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208061402.22815.arnd@arndb.de>
X-Provags-ID: V02:K0:WxhNicDqdlIGkBjZJgH0vDdNl0R2jCX0NCqR6VTKnl6
 AO7hdleV4RrIUZ71E2aZbfH9oeWiIElq4GvmbB8IhvUfv3Hz3V
 PkEkAE85mUlkXPOZQd9uKQ+P8fdkY06Wtgx+VS5WuJ9n7nTzLZ
 GHoTt5R4ycQh71h7hvE/i81/KBnS/oHxmZpxHhWXSDqg2sifLp
 aS6M2WdG/43gMCSYiLv/2YxPolVH71m0b9MkZzqKwy9iQU3/k7
 2xKBYS9PGZZk36788PQP2c5BWgVQgqG8ZKMW11MA3qBO3oxBOo
 y4RSdW6AK4/8aaKlObVK3DyjxyymCeY9CHSkTpukvEcmM/kN5y
 Z1qQ7XXuGAACR2Xm9xJ4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2012, Sebastian Hesselbarth wrote:
> This patch set adds DT support for Marvell Dove SoC and three boards
> equipped with this SoC. The work is based on device tree support for
> Marvell Orion based SoCs introduced in 3.6-rc1.
> 
> The first three patches move mach-dove closer to Marvell Kirkwood's
> setup code by unifying the clock setup routines, adding clock gating
> control, and support for Marvell's crypto engine to mach-dove.
> 
> Patches 4 and 5 add a generic DT machine descriptor to mach-dove and
> corresponding DT descriptors for the SoC and already supported boards.
> 
> Finally, the last patch adds a DT descriptor for the SolidRun CuBox,
> a plug computer based on Marvell Dove.
> 
> This patch set relies on a DT support patch for sdhci-dove that has
> been sent to the corresponding maintainers a few days ago.

This looks vert nice!

Acked-by: Arnd Bergmann <arnd@arndb.de>

Has anyone tested it on cm-a510 and dove-db? Once we can reasonably
assume that there are no regressions compared to using the board
files, I think we can plan for removing the non-DT support in
mach-dove. If it's been tested positively, that can well be at
the same time as adding the DT support, otherwise I think we should
wait a couple of releases while having both simultaneously.

	Arnd
