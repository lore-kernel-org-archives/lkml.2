Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab2JAX56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:57:58 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:60695 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847Ab2JAX5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:57:52 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 11/12] ARM: soc: documentation updates
Date: Mon,  1 Oct 2012 16:57:06 -0700
Message-Id: <1349135827-24790-12-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1349135827-24790-1-git-send-email-olof@lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation update for Marvell SoCs, the secret decoder ring to all
their crazy product names and numbers.

Conflicts: none.

----------------------------------------------------------------

The following changes since commit 7b27fa258c8f2670a8c09bbc6c4b2c874d155da2:

  Merge branch 'next/dt2' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/docs

for you to fetch changes up to c1faefbb5ba24957e0e5b519adf0e128380f49de:

  Merge branch 'marvell-doc' of git://github.com/MISL-EBU-System-SW/mainline-public into next/docs

----------------------------------------------------------------

Arnd Bergmann (1):
      Merge branch 'marvell-doc' of git://github.com/MISL-EBU-System-SW/mainline-public into next/docs

Thomas Petazzoni (1):
      arm: add documentation describing Marvell families of SoC


 Documentation/arm/Marvell/README | 232 ++++++++++++++++++++++++++++++++++
 1 file changed, 232 insertions(+)
 create mode 100644 Documentation/arm/Marvell/README
