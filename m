Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1JKLXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 07:23:46 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:39886 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1JKLXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 07:23:45 -0400
Subject: [PATCH] [TRIVIAL] h8300: drivers/serial/Kconfig was moved
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 13:23:29 +0200
Message-ID: <1318332209.18122.45.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ab4382d27412e7e3e7c936e8d50d8888dfac3df8 moved
drivers/serial/Kconfig to drivers/tty/serial/Kconfig, so we need to
source the latter file.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
The first release with this move was v2.6.38. Didn't anyone notice?
Perhaps the configuration tools silently skip invalid "source" files.
Anyhow, I added Yoshinori Sato, who perhaps can tell us whether sourcing
of this Kconfig is still needed for h8300.

 arch/h8300/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 091ed61..2b1eee7 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -195,7 +195,7 @@ config UNIX98_PTYS
 
 source "drivers/char/pcmcia/Kconfig"
 
-source "drivers/serial/Kconfig"
+source "drivers/tty/serial/Kconfig"
 
 source "drivers/i2c/Kconfig"
 
-- 
1.7.4.4

