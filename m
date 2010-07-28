Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0G1Ogd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:36:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60312 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0G1Og3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:36:29 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH 0/5] staging:ti dspbridge: Checkpatch errors cleanup series
Date: Wed, 28 Jul 2010 09:40:47 -0500
Message-Id: <1280328052-31292-1-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are targetted to remove checkpatch errors within
dspbridge driver.

Ernesto Ramos (5):
  staging:ti dspbridge: remove unused typedef REG16
  staging:ti dspbridge: remove unnecessary check for NULL pointer in
    cmm.c
  staging:ti dspbridge: remove function delete_strm_mgr
  staging:ti dspbridge: remove unnecessary volatile variables
  staging:ti dspbridge: replace simple_strtoul by strict_strtoul

 drivers/staging/tidspbridge/core/_tiomap.h    |    2 --
 drivers/staging/tidspbridge/core/tiomap3430.c |    8 ++++----
 drivers/staging/tidspbridge/dynload/tramp.c   |    4 ++--
 drivers/staging/tidspbridge/pmgr/cmm.c        |   15 ++++++---------
 drivers/staging/tidspbridge/rmgr/dbdcd.c      |    6 +++++-
 drivers/staging/tidspbridge/rmgr/strm.c       |   16 ++--------------
 6 files changed, 19 insertions(+), 32 deletions(-)

