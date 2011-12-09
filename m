Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1LIPFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:05:49 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:42897 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381Ab1LIPFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:05:48 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Dec 2011 10:05:48 EST
Message-ID: <4EE22276.7070100@comcast.net>
Date: Fri, 09 Dec 2011 10:00:06 -0500
From: Chris Metcalf <cdmetcalf@comcast.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile update for 3.2
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.2 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These changes mostly just allow 3.2 to build for tile, plus one
bug fix.

Chris Metcalf (5):
      arch/tile: add a few #includes and an EXPORT to catch up with kernel changes
      arch/tile: fix double-free bug in homecache_free_pages()
      asm-generic/unistd.h: support new process_vm_{readv,write} syscalls
      drivers/net/ethernet/tile: use skb_frag_page() API
      arch/tile: use new generic {enable,disable}_percpu_irq() routines

 arch/tile/include/asm/irq.h         |   10 ----------
 arch/tile/kernel/irq.c              |   16 ++++++++--------
 arch/tile/kernel/pci-dma.c          |    1 +
 arch/tile/kernel/pci.c              |    1 +
 arch/tile/kernel/sysfs.c            |    1 +
 arch/tile/lib/exports.c             |    3 +++
 arch/tile/mm/homecache.c            |    9 ++++++---
 drivers/net/ethernet/tile/tilepro.c |    8 ++++----
 include/asm-generic/unistd.h        |    8 +++++++-
 include/linux/compat.h              |    9 +++++++++
 10 files changed, 40 insertions(+), 26 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com



