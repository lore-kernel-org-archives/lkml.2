Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2GHTXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 15:23:50 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49974 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2GHTXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 15:23:34 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.10.162]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 8 Jul 2012 22:23:13 +0300
Message-ID: <CAK=WgbZsCy7ZaMATbyTtZvP6bHCLfroth0z=wFOZhtmMWBFAhg@mail.gmail.com>
Subject: [GIT PULL] remoteproc fixes for 3.5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Lindgren <tony@atomide.com>, "Grosen, Mark" <mgrosen@ti.com>,
        linux-kernel@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
tags/remoteproc-3.5-fixes

for you to fetch changes up to e121aefa7d9f10eee5cf26ed47129237a05d940b:

  remoteproc: fix missing CONFIG_FW_LOADER configurations (2012-07-04
11:01:12 +0300)

----------------------------------------------------------------
Two build-related remoteproc fixes for 3.5.

----------------------------------------------------------------
Ohad Ben-Cohen (2):
      remoteproc/omap: fix randconfig unmet direct dependencies
      remoteproc: fix missing CONFIG_FW_LOADER configurations

 drivers/remoteproc/Kconfig | 2 ++
 1 file changed, 2 insertions(+)
