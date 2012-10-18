Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab2JRBn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:43:27 -0400
Received: from noserose.net ([66.220.18.76]:52257 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753095Ab2JRBn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:43:26 -0400
Date: Wed, 17 Oct 2012 18:43:15 -0700
Message-Id: <cover.1350524227.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 0/9] aoe: various enhancements and cleanup from v50 to v60
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change since first submission:

	Go ahead and use the __must_hold() annotation provided
	recently by Josh Triplett, already in mm.

This patch series is based on linux-next/akpm from 11 Oct.

Ed L. Cashin (9):
  aoe: describe the behavior of the "err" character device
  aoe: print warning regarding a common reason for dropped transmits
  aoe: update cap on outstanding commands based on config query
    response
  aoe: support the forgetting (flushing) of a user-specified AoE target
  aoe: support larger I/O requests via aoe_maxsectors module param
  aoe: "payload" sysfs file exports per-AoE-command data transfer size
  aoe: cleanup: remove unused ata_scnt function
  aoe: whitespace cleanup
  aoe: update driver-internal version number to 60

 drivers/block/aoe/aoe.h     |   10 ++++----
 drivers/block/aoe/aoeblk.c  |   19 ++++++++++++++++++
 drivers/block/aoe/aoechr.c  |    7 +++++-
 drivers/block/aoe/aoecmd.c  |   22 +++++++-------------
 drivers/block/aoe/aoedev.c  |   44 +++++++++++++++++++++++++++++++++++++-----
 drivers/block/aoe/aoemain.c |    2 +-
 drivers/block/aoe/aoenet.c  |   11 ++++++---
 7 files changed, 84 insertions(+), 31 deletions(-)

