Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0HZQDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:03:19 -0400
Received: from mail.perches.com ([173.55.12.10]:1373 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab0HZQDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:03:18 -0400
Subject: [PATCH] MAINTAINERS: add W: todo lists
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        ksummit-2010-discuss@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1008261748520.1019@pobox.suse.cz>
References: <20100826154537.GA4874@linux.vnet.ibm.com>
	 <alpine.LNX.2.00.1008261748520.1019@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 09:03:15 -0700
Message-ID: <1282838596.1875.68.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also renamed NETWORKING patch queue from "W:" to "Q:"

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a1df54b..3d29d8c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2346,6 +2346,7 @@ FIREWIRE SUBSYSTEM
 M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://ieee1394.wiki.kernel.org/
+W:	https://ieee1394.wiki.kernel.org/index.php/To_Do
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/firewire/
@@ -4039,7 +4040,8 @@ NETWORKING [GENERAL]
 M:	"David S. Miller" <davem@davemloft.net>
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net
-W:	http://patchwork.ozlabs.org/project/netdev/list/
+W:	http://vger.kernel.org/~davem/net_todo.html
+Q:	http://patchwork.ozlabs.org/project/netdev/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
 S:	Maintained
@@ -4071,6 +4073,7 @@ S:	Maintained
 NETWORKING [WIRELESS]
 M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
+W:	http://wireless.kernel.org/en/developers/todo-list
 Q:	http://patchwork.kernel.org/project/linux-wireless/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
@@ -5114,6 +5117,7 @@ M:	James Morris <jmorris@namei.org>
 M:	Eric Paris <eparis@parisplace.org>
 L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
+W:	http://selinuxproject.org/page/Kernel_Development
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 S:	Supported
 F:	include/linux/selinux*


