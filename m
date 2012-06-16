Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab2FPVNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 17:13:25 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:36608 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756899Ab2FPVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 17:13:24 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jun 2012 17:13:24 EDT
Message-ID: <4FDCF59F.9030609@comcast.net>
Date: Sat, 16 Jun 2012 17:07:43 -0400
From: Chris Metcalf <cdmetcalf@comcast.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile update for 3.5-rc3
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull for 3.5-rc3 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git  stable

This one-line bug fix unbreaks glibc robust mutexes (among other things no
doubt), from code merged in during the 3.5 merge window but which we had
been running internally at Tilera for almost a year.

  tile: fix bug in get_user() for 4-byte values (2012-06-16 16:56:13 -0400)

----------------------------------------------------------------
Chris Metcalf (1):
      tile: fix bug in get_user() for 4-byte values

 arch/tile/include/asm/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

