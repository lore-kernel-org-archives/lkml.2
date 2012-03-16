Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161912Ab2CPBUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 21:20:19 -0400
Received: from tundra.namei.org ([65.99.196.166]:60550 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161704Ab2CPBUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 21:20:14 -0400
Date: Fri, 16 Mar 2012 12:20:11 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [GIT] MAINTAINERS: Add Serge as maintainer of capabilities
Message-ID: <alpine.LRH.2.02.1203161217060.32664@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this patch which adds Serge as maintainer of the 
capabilities code, as discussed on lwn and the lsm list.

New capabilities must be signed off by the maintainer, and new uses of any 
capabilities should at be cc'd to the maintainer.


The following changes since commit 0c4d0670f6e54f8507c30c01928cc9ff630ca497:
  Linus Torvalds (1):
        Merge branch 'akpm' (Andrew's patch-bomb)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

James Morris (1):
      MAINTAINERS: Add Serge as maintainer of capabilities

 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

commit 95d16c7211a5166d6e0241ca8c507718bef3c745
Author: James Morris <james.l.morris@oracle.com>
Date:   Fri Mar 16 12:05:48 2012 +1100

    MAINTAINERS: Add Serge as maintainer of capabilities
    
    Add Serge as maintainer of capabilities, per suggestion on LWN:
    http://lwn.net/Articles/486306/
    
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 03e0b48..9c63a43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1721,6 +1721,14 @@ F:	include/linux/can/error.h
 F:	include/linux/can/netlink.h
 F:	include/linux/can/platform/
 
+CAPABILITIES
+M:	Serge Hallyn <serge.hallyn@canonical.com>
+L:	linux-security-module@vger.kernel.org
+S:	Supported	
+F:	include/linux/capability.h
+F:	security/capability.c
+F:	security/commoncap.c 
+
 CELL BROADBAND ENGINE ARCHITECTURE
 M:	Arnd Bergmann <arnd@arndb.de>
 L:	linuxppc-dev@lists.ozlabs.org
