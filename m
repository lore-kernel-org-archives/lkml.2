Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab1GXGKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 02:10:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51609 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab1GXGKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 02:10:04 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 24 Jul 2011 00:09:43 -0600
X-Google-Sender-Auth: Rn8utFyefHs2neO_yMXmE1qxCMo
Message-ID: <CACxGe6urOHDTO5R515RK8+Rtg4C_v=XtXA=+xkzFqE5M4M3_TA@mail.gmail.com>
Subject: [GIT PULL] device tree build fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6d6be43d4dfdb167ef72f4aa665c1607db799be4:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin
(2011-07-23 14:05:44 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/next

Grant Likely (1):
      of: fix missing include from of_pci.c

 drivers/of/of_pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
