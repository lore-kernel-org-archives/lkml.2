Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0FWLPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 07:15:43 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:40898 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516Ab0FWLPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 07:15:36 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
       Benjamin Tissoires <tissoire@cena.fr>,
       Chase Douglas <chase.douglas@canonical.com>,
       Rafi Rubin <rafi@seas.upenn.edu>, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/4] input: evdev: Dynamic buffers (rev5)
Date: Wed, 23 Jun 2010 13:14:41 +0200
Message-Id: <1277291686-7153-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1ORNut-0007KG-4z.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1ORNut-0007KG-4z 6e337d35e35441fa5730ca151828868e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Please find enclosed the fifth version of the evdev buffer patches.

In this version, the buffer scheme is left intact, leaving a single
patch to make the client buffers dynamic. Mostly harmless.

The rest of the patches are rebased versions of what has already been
sent, and summarizes what seems to be needed to fix the original
buffer problem. The last patch is a bonus which fixes an old bug.

Thanks,
Henrik

Henrik Rydberg (5):
  input: evdev: Convert to dynamic event buffer (rev5)
  input: Use driver hint to compute the evdev buffer size (rev3)
  input: bcm5974: Set the average number of events per MT event packet
  hid-input: Use a larger event buffer for MT devices
  input: evdev: Never leave the client buffer empty after write

 drivers/hid/hid-input.c       |    3 +++
 drivers/input/evdev.c         |   33 ++++++++++++++++++++++++++++-----
 drivers/input/mouse/bcm5974.c |    2 ++
 include/linux/input.h         |   17 +++++++++++++++++
 4 files changed, 50 insertions(+), 5 deletions(-)

