Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0D1T6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:58:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51453 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab0D1T6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:58:50 -0400
Subject: [GIT PULL] regulator fix for 2.6.34-rc6
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 20:58:42 +0100
Message-ID: <1272484722.3224.777.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following regulator fix for 2.6.34-rc6. The MAX8925
voltage regulators are non-functional without it.

Thanks

Liam

---

The following changes since commit 1600f9def09de07c5dbeb539e978fa73880690dd:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jmorris/security-testing-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Haojian Zhuang (1):
      regulator: fix enabling regulator issue on max8925

 drivers/regulator/max8925-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


