Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab2FRUdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:33:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab2FRUdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:33:20 -0400
Message-ID: <4FDF908C.6010404@redhat.com>
Date: Mon, 18 Jun 2012 17:33:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux EDAC Mailing List <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [GIT PULL for 3.5-rc4] EDAC fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git master

For some fixes for EDAC.

Thanks,
Mauro

Latest commit at the branch: 
8447c4d15e357a458c9051ddc84aa6c8b9c27000 edac: Do alignment logic properly in edac_align_ptr()
The following changes since commit cfaf025112d3856637ff34a767ef785ef5cf2ca9:

  Linux 3.5-rc2 (2012-06-08 18:40:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git master

for you to fetch changes up to 8447c4d15e357a458c9051ddc84aa6c8b9c27000:

  edac: Do alignment logic properly in edac_align_ptr() (2012-06-11 12:43:16 -0300)

----------------------------------------------------------------
Chen Gong (2):
      edac: avoid mce decoding crash after edac driver unloaded
      edac: fix the error about memory type detection on SandyBridge

Chris Metcalf (1):
      edac: Do alignment logic properly in edac_align_ptr()

Kim Phillips (1):
      mpc85xx_edac: fix error: too few arguments to function 'edac_mc_alloc'

 drivers/edac/edac_mc.c      |    2 +-
 drivers/edac/i7core_edac.c  |   15 ++++-----------
 drivers/edac/mpc85xx_edac.c |    3 ++-
 drivers/edac/sb_edac.c      |   10 +++++-----
 4 files changed, 12 insertions(+), 18 deletions(-)

