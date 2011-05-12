Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab1ELTMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:12:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:57004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab1ELTMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:12:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Russell King <linux@arm.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [PATCH 0/3] Fix 8390 regressions
Date: Thu, 12 May 2011 19:11:37 +0000
Message-Id: <1305227500-15595-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.5.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 May 2011 19:11:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix regressions in 3 8390-based network drivers:
 [1/3] zorro8390: Fix regression caused during net_device_ops conversion
 [2/3] hydra: Fix regression caused during net_device_ops conversion
 [3/3] ne-h8300: Fix regression caused during net_device_ops conversion

The first one, for zorro8390, has been tested.
The second one, for hydra, has been compile-tested only.

Based on commits 8cfd9e923be54ef66ce174a93f4592b444b96407 ("[ARM] RiscPC: Fix
etherh oops") and 217cbfa856dc1cbc2890781626c4032d9e3ec59f ("mac8390: fix
regression caused during net_device_ops conversion"), and the patch for
zorro8390, we have good reasons to believe hydra and ne-h8300 are affected
as well, as they all include lib8390.c.
Hence patches for those are also included, although I could not test them.

Gr{oetje,eeting}s,

                                                Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                                            -- Linus Torvalds

