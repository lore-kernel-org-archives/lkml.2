Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1BBMje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:39:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab1BBMjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:39:33 -0500
Message-ID: <4D495062.2070802@redhat.com>
Date: Wed, 02 Feb 2011 10:38:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v2.6.38-rc5] V4L/DVB fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git media_fixes

For:
	- some fixes on some Remote Controller drivers;
	- some gspca/zc3xx fixes;
	- a trivial one-line fix for saa7111 detection.

The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git media_fixes

Jarod Wilson (8):
      [media] rc/mce: add mappings for missing keys
      [media] hdpvr: fix up i2c device registration
      [media] lirc_zilog: z8 on usb doesn't like back-to-back i2c_master_send
      [media] ir-kbd-i2c: improve remote behavior with z8 behind usb
      [media] rc/ir-lirc-codec: add back debug spew
      [media] rc: use time unit conversion macros correctly
      [media] mceusb: really fix remaining keybounce issues
      [media] rc/streamzap: fix reporting response times

Jean-François Moine (3):
      [media] gspca - zc3xx: Bad delay when given by a table
      [media] gspca - zc3xx: Fix bad images with the sensor hv7131r
      [media] gspca - zc3xx: Discard the partial frames

Russell King (1):
      [media] fix saa7111 non-detection

 drivers/media/rc/ir-lirc-codec.c               |    6 +++-
 drivers/media/rc/keymaps/rc-rc6-mce.c          |    6 ++++
 drivers/media/rc/mceusb.c                      |    9 ++++--
 drivers/media/rc/nuvoton-cir.c                 |    6 ++--
 drivers/media/rc/streamzap.c                   |   14 ++++++----
 drivers/media/video/gspca/zc3xx.c              |   31 +++++++++++++++++++---
 drivers/media/video/hdpvr/hdpvr-core.c         |   24 +++++++++++++++---
 drivers/media/video/hdpvr/hdpvr-i2c.c          |   30 ++++++++++++++--------
 drivers/media/video/hdpvr/hdpvr.h              |    3 +-
 drivers/media/video/ir-kbd-i2c.c               |   13 +++++++++
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    1 -
 drivers/media/video/saa7115.c                  |    2 +-
 drivers/staging/lirc/lirc_zilog.c              |   32 +++++++++++++++++++----
 13 files changed, 135 insertions(+), 42 deletions(-)

