Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1FMPVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:21:49 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:36792 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1FMPVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:21:48 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 13 Jun 2011 09:21:28 -0600
X-Google-Sender-Auth: zFPansE5BddenFH_hDoiJ919KVU
Message-ID: <BANLkTinFf+au5ofWiHoE7r2-2HB4tx+OQQ@mail.gmail.com>
Subject: [GIT PULL] spi bug fix
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3c25fa740e2084a3950f581378ec29a3c307ddfc:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable
(2011-06-12 11:06:36 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi/merge

Virupax Sadashivpetimath (1):
      spi-pl022: Add missing return value update

 drivers/spi/amba-pl022.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
