Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0CVHXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:23:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49611 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab0CVHXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:23:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-i2c@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 0/5] Blackfin I2C updates
Date: Mon, 22 Mar 2010 03:23:15 -0400
Message-Id: <1269242600-30147-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were posted a few months ago, but seem to have stalled.

These can also be pulled from:
	  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-i2c

Michael Hennerich (1):
  i2c-bfin-twi: add debug output for error status

Sonic Zhang (4):
  i2c-bfin-twi: integrate timeout timer with completion interface
  i2c-bfin-twi: fix lost interrupts at high speeds
  i2c-bfin-twi: remove redundant retry
  i2c-bfin-twi: return completion in interrupt for smbus quick
    transfers

 drivers/i2c/busses/i2c-bfin-twi.c |  168 +++++++++++++++++--------------------
 1 files changed, 78 insertions(+), 90 deletions(-)

