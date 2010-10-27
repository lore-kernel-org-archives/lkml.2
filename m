Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab0J0RTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:19:20 -0400
Received: from mail.perches.com ([173.55.12.10]:3627 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0J0RTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:19:16 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 0/2] drivers/input/serio: Use pr_fmt and pr_<level>
Date: Wed, 27 Oct 2010 10:19:09 -0700
Message-Id: <cover.1288198838.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize the logging messages a bit.

Joe Perches (2):
  drivers/input/serio/i8042: Use pr_<level>, pr_fmt. Fix dbg and __FILE__ use
  drivers/input/serio: Use pr_fmt and pr_<level>

 drivers/input/serio/ambakmi.c         |    5 ++-
 drivers/input/serio/ct82c710.c        |   10 ++--
 drivers/input/serio/gscps2.c          |   15 +++---
 drivers/input/serio/hil_mlc.c         |   17 +++---
 drivers/input/serio/hp_sdc.c          |   51 +++++++++---------
 drivers/input/serio/hp_sdc_mlc.c      |   46 ++++++++--------
 drivers/input/serio/i8042-x86ia64io.h |    2 +-
 drivers/input/serio/i8042.c           |   94 +++++++++++++++-----------------
 drivers/input/serio/i8042.h           |   19 ++++---
 drivers/input/serio/maceps2.c         |    5 ++-
 drivers/input/serio/parkbd.c          |    8 ++-
 drivers/input/serio/q40kbd.c          |    6 ++-
 drivers/input/serio/rpckbd.c          |    6 ++-
 drivers/input/serio/sa1111ps2.c       |   11 +++--
 drivers/input/serio/serio.c           |    8 ++--
 drivers/input/serio/serio_raw.c       |    8 ++-
 drivers/input/serio/serport.c         |    6 ++-
 17 files changed, 167 insertions(+), 150 deletions(-)

-- 
1.7.3.1.g432b3.dirty

