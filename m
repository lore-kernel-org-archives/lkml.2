Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1LYNbE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 08:31:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58228 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1LYNbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 08:31:02 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 25 Dec 2011 14:30:46 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] trivial FireWire update
Message-ID: <20111225143046.337f44b5@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the signed tag "for-linus" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git refs/tags/for-linus

to receive an update to the MAINTAINERS file.  I did not hold this
trivial pull request off until you open the next merge window since
I do not expect to have anything more to pull by then.

Stefan Richter (1):
      MAINTAINERS: firewire git URL update

 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 28f65c2..37deb5e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2624,7 +2624,7 @@ FIREWIRE SUBSYSTEM
 M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://ieee1394.wiki.kernel.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git
 S:	Maintained
 F:	drivers/firewire/
 F:	include/linux/firewire*.h
-- 
Stefan Richter
-=====-==-== ==-- ==--=
http://arcgraph.de/sr/
