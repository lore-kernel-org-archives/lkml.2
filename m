Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966827Ab2ERTPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 15:15:55 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:43462 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966736Ab2ERTPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 15:15:51 -0400
Message-ID: <4FB69FE6.4030806@tilera.com>
Date: Fri, 18 May 2012 15:15:50 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tile tree bug fix for v3.4
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull one more bug fix for 3.4 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This fixes a security vulnerability (and correctness bug) in tilegx.  Thanks!

Chris Metcalf (1):
      tilegx: enable SYSCALL_WRAPPERS support

 arch/tile/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


