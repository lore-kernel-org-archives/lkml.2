Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0LBK7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:59:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43465 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0LBK7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:59:17 -0500
Subject: [GIT PULL] regulator fixes for 2.6.37-rc5
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 10:59:13 +0000
Message-ID: <1291287553.3262.45.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following regulator fixes for 2.6.37-rc5.

Thanks

Liam

---

The following changes since commit e8a7e48bb248a1196484d3f8afa53bded2b24e71:

  Linux 2.6.37-rc4 (2010-11-29 20:42:04 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Axel Lin (4):
      regulator: Remove a redundant device_remove_file call in create_regulator
      regulator: Ensure enough delay time for enabling regulator
      regulator: Return proper error for regulator_register()
      regulator: twl-regulator - fix twlreg_set_mode

Bengt Jonsson (1):
      regulator: enable supply regulator only when use count is zero

Mark Brown (1):
      regulator: Staticise mc13783_powermisc_rmw()

Mattias Wallin (2):
      regulator: regulator disable supply fix
      regulator: lock supply in regulator enable

Randy Dunlap (1):
      regulator: fix kernel-doc for set_consumer_device_supply

 drivers/regulator/core.c              |   30 +++++++++++++++++++-----------
 drivers/regulator/mc13783-regulator.c |    4 ++--
 drivers/regulator/twl-regulator.c     |    6 +++---
 3 files changed, 24 insertions(+), 16 deletions(-)


