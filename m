Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2KSXai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:30:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48162 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2KSXaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:30:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Cypress Semiconductor Corporation <customercare@cypress.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 0/2] Cypress PS/2 Trackpad driver
Date: Mon, 19 Nov 2012 15:30:35 -0800
Message-Id: <1353367837-18229-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver, submitted on behalf of Cypress Semiconductor Corporation and
additional contributors, provides support for the Cypress PS/2 Trackpad.

This version is equivalent to that currently shipping in Ubuntu[0].

Note the recent list discussion[1] about the psmouse-base changes in
patch #2 ("link into psmouse-base").  Further patches to ameliorate the
psmouse integration are, of course, invited.

 -Kamal Mostafa <kamal@canonical.com>

[0] http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-quantal.git&a=search&h=HEAD&st=commit&s=Cypress+PS/2
[1] http://www.spinics.net/lists/linux-input/msg23467.html


Cypress Semiconductor Corporation (2):
  input: Cypress PS/2 Trackpad psmouse driver
  input: Cypress PS/2 Trackpad link into psmouse-base

 drivers/input/mouse/Kconfig        |   10 +
 drivers/input/mouse/Makefile       |    1 +
 drivers/input/mouse/cypress_ps2.c  |  956 ++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cypress_ps2.h  |  220 +++++++++
 drivers/input/mouse/psmouse-base.c |   40 ++
 drivers/input/mouse/psmouse.h      |    2 +
 6 files changed, 1229 insertions(+)
 create mode 100644 drivers/input/mouse/cypress_ps2.c
 create mode 100644 drivers/input/mouse/cypress_ps2.h

-- 
1.7.10.4

