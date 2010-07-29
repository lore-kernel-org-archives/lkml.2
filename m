Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab0G2SGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 14:06:05 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:24486 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab0G2SGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 14:06:01 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOZfUUzZiBZX/2dsb2JhbACgCXLAXQ2FKwSEOg
Date: Thu, 29 Jul 2010 20:05:59 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: [WATCHDOG] Update Maintainers info
Message-ID: <20100729180559.GD30740@infomag.iguana.be>
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

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Jul 29 18:02:51 2010 +0000

    watchdog: update MAINTAINERS entry
    
    Add Mailing-list and website to watchdog MAINTAINERS entry.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/MAINTAINERS b/MAINTAINERS
index db3d0f5..02f75fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6243,6 +6243,8 @@ F:	drivers/mmc/host/wbsd.*
 
 WATCHDOG DEVICE DRIVERS
 M:	Wim Van Sebroeck <wim@iguana.be>
+L:	linux-watchdog@vger.kernel.org
+W:	http://www.linux-watchdog.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
 S:	Maintained
 F:	Documentation/watchdog/
