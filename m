Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1EITpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:45:32 -0400
Received: from mail.perches.com ([173.55.12.10]:1396 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120Ab1EITpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:45:31 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] tulip: logging cleanups
Date: Mon,  9 May 2011 12:45:19 -0700
Message-Id: <cover.1304970062.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More like 30 minutes.

Joe Perches (4):
  tulip: xircom_cb: Convert #ifdef DEBUG blocks and enter/leave uses
  tulip: Convert printks to netdev_<level>
  tulip: Convert uses of KERN_DEBUG
  tulip: Use pr_<level> where appropriate

 drivers/net/tulip/21142.c       |   14 +-
 drivers/net/tulip/Makefile      |    2 +
 drivers/net/tulip/de2104x.c     |  174 +++++++++++--------------
 drivers/net/tulip/dmfe.c        |    9 +-
 drivers/net/tulip/eeprom.c      |    4 +-
 drivers/net/tulip/interrupt.c   |   48 ++++----
 drivers/net/tulip/media.c       |   49 ++++----
 drivers/net/tulip/pnic.c        |   22 ++--
 drivers/net/tulip/pnic2.c       |   16 +-
 drivers/net/tulip/timer.c       |   47 +++----
 drivers/net/tulip/tulip.h       |    8 +-
 drivers/net/tulip/tulip_core.c  |   50 ++++----
 drivers/net/tulip/uli526x.c     |   65 +++------
 drivers/net/tulip/winbond-840.c |   81 ++++++------
 drivers/net/tulip/xircom_cb.c   |  268 ++++++++++++--------------------------
 15 files changed, 354 insertions(+), 503 deletions(-)

-- 
1.7.5.rc3.dirty

