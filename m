Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab2DZT7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:59:45 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:22109 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab2DZT7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:59:44 -0400
Message-ID: <4F99A92E.4030202@tilera.com>
Date: Thu, 26 Apr 2012 15:59:42 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tile tree bug fixes for v3.4-rc5
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.4-rc5 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

One change fixes a platform-independent bug about environment var handling
in the boot command line.  The other is a trivial tile-specific bug fix to
avoid a link-time warning.

Chris Metcalf (2):
      init: fix bug where environment vars can't be passed via boot args
      arch/tile: fix a couple of functions that should be __init

 arch/tile/include/asm/pci.h |    4 ++--
 arch/tile/kernel/pci.c      |    4 ++--
 init/main.c                 |   25 +++++++++++++------------
 3 files changed, 17 insertions(+), 16 deletions(-)


-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

