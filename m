Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab0GAQ2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:28:30 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:14864 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755852Ab0GAQ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:28:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHZeLEzZiBXw/2dsb2JhbACfZXK/Pw2FGASEEw
Date: Thu, 1 Jul 2010 18:07:11 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Fabio Estevam <fabio.estevam@freescale.com>
Subject: [WATCHDOG] v2.6.35-rc4 patch
Message-ID: <20100701160711.GU3788@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 Documentation/watchdog/watchdog-parameters.txt |    5 +++++
 1 file changed, 5 insertions(+)

with these Changes:

Author: Fabio Estevam <fabio.estevam@freescale.com>
Date:   Thu Jun 24 09:43:25 2010 -0700

    watchdog: docs: add an entry for imx2_wdt
    
    Add an entry for imx2_wdt in watchdog-parameters.txt
    
    Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/watchdog-parameters.txt b/Documentation/watchdog/watchdog-parameters.txt
index 41c95cc..17ddd82 100644
--- a/Documentation/watchdog/watchdog-parameters.txt
+++ b/Documentation/watchdog/watchdog-parameters.txt
@@ -125,6 +125,11 @@ ibmasr:
 nowayout: Watchdog cannot be stopped once started
 	(default=kernel config parameter)
 -------------------------------------------------
+imx2_wdt:
+timeout: Watchdog timeout in seconds (default 60 s)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
 indydog:
 nowayout: Watchdog cannot be stopped once started
 	(default=kernel config parameter)
