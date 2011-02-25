Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab1BYVdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:33:19 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56005 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab1BYVdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:33:18 -0500
Subject: [GIT PULL] Regulator fixes for 2.6.38
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 21:33:13 +0000
Message-ID: <1298669593.3356.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following regulator fixes for 2.6.38.

Thanks

Liam

---

The following changes since commit 4662db446190ddef8fbab024f72dee77dd04b8f2:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-02-24 17:08:48 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Jesper Juhl (1):
      regulator, mc13xxx: Remove pointless test for unsigned less than zero

Mark Brown (1):
      regulator: Fix warning with CONFIG_BUG disabled

 drivers/regulator/mc13xxx-regulator-core.c |    2 +-
 drivers/regulator/wm831x-dcdc.c            |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)


