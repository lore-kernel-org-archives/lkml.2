Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1HWOXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:23:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43340 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab1HWOXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:23:39 -0400
Date: Tue, 23 Aug 2011 18:23:34 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>, Axel Lin <axel.lin@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-3.1.git
Message-ID: <20110823142334.GA22335@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-3.1.git tree to receive a few module.h-related
compilation bugfixes.

Thanks,

The following changes since commit 93ee7a9340d64f20295aacc3fb6a22b759323280:

  Linux 3.1-rc2 (2011-08-14 15:09:08 -0700)

are available in the git repository at:
  git://git.infradead.org/users/cbou/battery-3.1.git master

Axel Lin (1):
      max8997_charger: Needs module.h

Randy Dunlap (1):
      max8998_charger: Needs module.h

Vasily Khoruzhick (1):
      s3c-adc-battery: Fix compilation error due to missing header (module.h)

 drivers/power/max8997_charger.c |    1 +
 drivers/power/max8998_charger.c |    1 +
 drivers/power/s3c_adc_battery.c |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)
