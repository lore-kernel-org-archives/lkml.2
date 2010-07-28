Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0G1Ouc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:50:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35828 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab0G1Ou3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:50:29 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH 0/4] staging:ti dspbridge: Fix IVA2 power OFF series
Date: Wed, 28 Jul 2010 09:54:51 -0500
Message-Id: <1280328895-31375-1-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes issues that prevent IVA2 to turn OFF when
there are issues to load the base image and makes sure IVA2 switched OFF
when dsp bridge driver is installed.

Ernesto Ramos (4):
  staging:ti dspbridge: fix bridge_brd_stop so IVA2 is set OFF
  staging:ti dspbridge: proc_load/start should set IVA2 to OFF in case
    of failure
  staging:ti dspbridge: make sure IVA2 is OFF when dev is created
  staging:ti dspbridge: remove bridge_brd_delete function

 drivers/staging/tidspbridge/core/tiomap3430.c |   65 ++----------------------
 drivers/staging/tidspbridge/rmgr/proc.c       |    6 ++-
 2 files changed, 10 insertions(+), 61 deletions(-)

