Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038Ab1CTEye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 00:54:34 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:36973 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1CTEyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 00:54:32 -0400
Message-ID: <4D858886.70500@tilera.com>
Date: Sun, 20 Mar 2011 00:54:30 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Michel Lespinasse <walken@google.com>
Subject: [GIT PULL] arch/tile updates for v2.6.39
References: <4D8263DB.1010500@tilera.com>
In-Reply-To: <4D8263DB.1010500@tilera.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull some follow-on changes for 2.6.39.

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

One change adds a missing syscall to <asm-generic/unistd.h>;
Arnd asked me to pass it to you through my tree.

The other fixes a problem with the futex sanitization change
in the tile architecture (an incomplete change from int to u32).

These changes fix the two current build problems I see in
the tile tree.

Chris Metcalf (2):
      arch/tile: fix futex sanitization definition/prototype mismatch
      asm-generic: support clock_adjtime() in <asm-generic/unistd.h>

 arch/tile/lib/atomic_32.c    |   12 ++++++------
 include/asm-generic/unistd.h |    4 +++-
 2 files changed, 9 insertions(+), 7 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

