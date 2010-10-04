Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab0JDTmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:42:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33556 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab0JDTmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:42:05 -0400
Subject: [GIT PULL] regulator fixes for 2.6.36
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 20:42:05 +0100
Message-ID: <1286221325.3148.134.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following regulator fixes.

Thanks

Liam

---

The following changes since commit c6ea21e35bf3691cad59647c771e6606067f627d:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sfrench/cifs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Axel Lin (1):
      regulator: max8649 - fix setting extclk_freq

Cyril Chemparathy (1):
      regulator: fix typo in current units

Vasiliy Kulikov (1):
      regulator: fix device_register() error handling

 drivers/regulator/core.c    |    6 ++++--
 drivers/regulator/max8649.c |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)


