Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab2BMUPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:15:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41866 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab2BMUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:15:28 -0500
Date: Tue, 14 Feb 2012 00:15:22 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-urgent.git
Message-ID: <20120213201522.GA23907@oksana.dev.rtsoft.ru>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Let's try requesting pull via the signed tag thing...

- - - -
The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)

are available in the git repository at:

  git://git.infradead.org/users/cbou/battery-urgent.git battery-fixes-for-v3.3-rc2

for you to fetch changes up to 455a0e2cd80f7a2849b2e6d3be85c053ee44446b:

  lp8727_charger: Add terminating entry for i2c_device_id table (2012-02-01 21:34:26 +0400)

----------------------------------------------------------------
Just a few small fixes for a bunch of drivers. Nothing noteworthy.

----------------------------------------------------------------
Anton Vorontsov (1):
      Revert "bq27x00_battery: Fix reporting status value for bq27500 battery"

Axel Lin (2):
      power_supply: Fix modalias for charger-manager
      lp8727_charger: Add terminating entry for i2c_device_id table

Grazvydas Ignotas (1):
      bq27x00_battery: Fix flag register read

Kim, Milo (1):
      lp8727_chager: Fix permissions on a header file

 drivers/power/bq27x00_battery.c |   15 +++++----------
 drivers/power/charger-manager.c |    4 ++--
 drivers/power/lp8727_charger.c  |    1 +
 3 files changed, 8 insertions(+), 12 deletions(-)
 mode change 100755 => 100644 include/linux/lp8727.h
