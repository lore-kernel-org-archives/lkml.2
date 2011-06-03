Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1FCRAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:00:03 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:59989 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab1FCRAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:00:02 -0400
Message-ID: <4DE9130B.8040306@tilera.com>
Date: Fri, 3 Jun 2011 12:59:55 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] fixes for arch/tile for 3.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull for 3.0 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This adds support to asm-generic for the new sendmmsg syscall, and
also enables backtrace reporting on panic for tile.  They are each
basically one-line fixes.

Chris Metcalf (2):
      tile: enable CONFIG_BUGVERBOSE
      asm-generic/unistd.h: support sendmmsg syscall

 include/asm-generic/unistd.h |    4 +++-
 lib/Kconfig.debug            |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


