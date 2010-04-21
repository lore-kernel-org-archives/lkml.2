Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0DUO36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:29:58 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:44246 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab0DUO3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:29:54 -0400
Subject: [GIT PULL] regulator fixes for 2.6.34-rc6
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 15:29:48 +0100
Message-ID: <1271860188.3234.41.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following two regulator fixes for 2.6.34-rc6

Thanks

Liam

---

The following changes since commit 13bd8e4673d527a9e48f41956b11d391e7c2cfe0:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../anholt/drm-intel

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Axel Lin (1):
      mc13783-regulator: fix a memory leak in mc13783_regulator_remove

Jean Delvare (1):
      regulator: Let drivers know when they use the stub API

 drivers/regulator/mc13783-regulator.c |    3 +++
 include/linux/regulator/consumer.h    |    8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)


