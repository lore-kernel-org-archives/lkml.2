Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab2CHQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:16:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2CHQQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:16:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the omap_dss2 tree
Date: Thu, 8 Mar 2012 16:16:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
References: <20120308170048.f1a992bca2ca2d93fa9747bf@canb.auug.org.au>
In-Reply-To: <20120308170048.f1a992bca2ca2d93fa9747bf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203081616.12510.arnd@arndb.de>
X-Provags-ID: V02:K0:PNlWkx9PoxUCr5c6UoJfCfQvn9tRBeXlO24VFw5/BXR
 CEjUJHSQZ/aFqTDT43HWeOVvze9+LP7ThCpjEUaY6IFdx8tu8/
 rcBL/eEa/jtwm51JyQwSsKBTEZ/ZODDuYhHkM7CGp9c9JkE2rR
 0YZm9sovjp0EJs86dO8oLMJRhUf5rOuNP8o7kHqYTJlRVQk0Kv
 zNvTDfBwA/lf9tksET6SSRjp8LNeWIIm0pZ1wulO0A1kuVzB4v
 sgdKui+ZWZ4Nu6E2NZXXCTkG9g9pBVbTc0/xfLjHFTHL5Ry6OA
 DYo6UbAnFRNB3RiOpt6Aa8rITDPcXms2ZZRJUIzUC4ndBajIGm
 kz3Iw1pQBKk5TgumPZsc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 March 2012, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-omap1/board-palmtt.c between commit ddba6c7f7ec6 ("OMAP1:
> pass LCD config with omapfb_set_lcd_config()") from the omap_dss2 tree
> and commit 2e3ee9f45b3c ("ARM: OMAP1: Move most of plat/io.h into local
> iomap.h") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Hi Stephen,

Thanks for fixing up all the conflicts between arm-soc and omap_dss2.
I think we should make sure they are resolved in one of the trees before
the merge window.

Tomi, what are your plans for the omap_dss2 branch to get merged?
Do you think you should send it to Linus first and we merge it into
arm-soc to resolve the conflicts?
Or do you want to merge it through the arm-soc tree?
Or should we go first and you fix up the conflicts by pulling in the
necessary topic branches from arm-soc into your tree?

	Arnd

