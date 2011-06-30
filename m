Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1F3Ltx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:49:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43128 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1F3Ltq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:49:46 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 0/3 v3] ideapad: add backlight driver and changes of sysfs nodes
Date: Thu, 30 Jun 2011 19:49:44 +0800
Message-Id: <1309434584-4636-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes after last post:
 * In show_ideapad_cfg, Using %lX to avoid one cast.
 * When fail from reading EC, return -EIO
 * Not to change the parameter of ideapad_sync_rfk_state
 * Add backlight type

Patches are available in the git repository at:
  git://kernel.ubuntu.com/ikepanhc/ideapad-laptop.git ideapad-laptop

Ike Panhc (3):
  ideapad: define cfg bits and create sysfs node for cfg
  ideapad: let camera_power node invisiable if no camera
  ideapad: add backlight driver

 .../ABI/testing/sysfs-platform-ideapad-laptop      |   17 ++
 drivers/platform/x86/ideapad-laptop.c              |  192 +++++++++++++++++---
 2 files changed, 187 insertions(+), 22 deletions(-)

-- 
1.7.4.1

