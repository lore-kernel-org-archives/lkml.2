Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab0IXWeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 18:34:08 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:44317 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab0IXWeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 18:34:07 -0400
Message-ID: <4C9D275A.5030405@tilera.com>
Date: Fri, 24 Sep 2010 18:34:02 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] arch/tile fixes for 2.6.36
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

to get one toolchain-related bug fix for arch/tile/ for 2.6.36.  The commit
describes the problem, but basically a good fix in our compiler causes a
mysterious failure in our assembler, and conveniently, removing some dead
code in an assembly file avoids having to back out the good fix, as well as
allowing the existing toolchain to compile 2.6.36.

Thanks!

Chris Metcalf (1):
      arch/tile: remove dead code from intvec_32.S

 arch/tile/kernel/intvec_32.S |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

