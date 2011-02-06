Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1BFTKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:10:44 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:58599 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1BFTKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:10:43 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: [PULL REQ] IXP4xx: a couple of fixes
Date: Sun, 06 Feb 2011 20:09:35 +0100
Message-ID: <m34o8hou8g.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

the following changes since commit ebf53826e105f488f4f628703a108e98940d1dc5:

  Linux 2.6.38-rc3 (2011-02-01 13:05:49 +1000)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git ixp4xx

Ben Hutchings (1):
      arm/ixp4xx: Rename FREQ macro to avoid collisions

Krzysztof Hałasa (1):
      IXP4xx: Fix qmgr_release_queue() flushing unexpected queue entries.

Please pull. Thanks.

 arch/arm/mach-ixp4xx/common.c             |    4 ++--
 arch/arm/mach-ixp4xx/include/mach/timex.h |    5 +++--
 arch/arm/mach-ixp4xx/ixp4xx_qmgr.c        |    9 +++++----
 drivers/input/misc/ixp4xx-beeper.c        |    6 +-----
 4 files changed, 11 insertions(+), 13 deletions(-)
-- 
Krzysztof Halasa
