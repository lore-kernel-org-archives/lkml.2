Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0LJWY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:24:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47794 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0LJWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:24:54 -0500
Subject: [GIT PULL] Regulator fixes for 2.6.37
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 22:24:50 +0000
Message-ID: <1292019890.3422.18.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following regulator fixes for 2.6.37. The fixes are all for the TI TPS6586x PMIC.

Thanks

Liam

---

The following changes since commit 6313e3c21743cc88bb5bd8aa72948ee1e83937b6:

  Merge branches 'x86-fixes-for-linus', 'perf-fixes-for-linus' and 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-12-08 06:40:59 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Danny Huang (4):
      regulator: tps6586x: Add missing bit mask generation
      regulator: tps6586x: Fix TPS6586X_DVM to store goreg/bit
      regulator: tps6586x: Handle both enable reg/bits being the same
      regulator: tps6586x: correct register table

 drivers/regulator/tps6586x-regulator.c |   33 +++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 11 deletions(-)


