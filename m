Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab2GFIHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:07:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2GFIHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:07:13 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH 0/4] ideapad: patches for v3.6 merge window
Date: Fri,  6 Jul 2012 16:07:03 +0800
Message-Id: <1341562023-6951-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <4FF45C98.60305@gmail.com>
References: <4FF45C98.60305@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One minor fix on part 2 for z570 is to let CONFIG_IDEAPAD depends on
CONFIG_SERIO_I8042


The following changes since commit 71351f14b3b941eb7178567b1272d934609cb785:

  Linux 3.5-rc5 (2012-07-05 14:09:43 +0800)

are available in the git repository at:

  git://kernel.ubuntu.com/ikepanhc/public.git ideapad-3.6

for you to fetch changes up to 583f18e1378d1b15fa35333be02b79e4f9315f59:

  ideapad: add Lenovo IdeaPad Z570 support (part 3) (2012-07-06 15:12:49 +0800)


Dan Carpenter (1):
  ideapad: uninitialized data in ideapad_acpi_add()

Maxim Mikityanskiy (3):
  ideapad: add Lenovo IdeaPad Z570 support (part 1)
  ideapad: add Lenovo IdeaPad Z570 support (part 2)
  ideapad: add Lenovo IdeaPad Z570 support (part 3)

 .../ABI/testing/sysfs-platform-ideapad-laptop      |   11 ++
 drivers/platform/x86/Kconfig                       |    1 +
 drivers/platform/x86/ideapad-laptop.c              |  115 ++++++++++++++++++--
 3 files changed, 120 insertions(+), 7 deletions(-)

-- 
1.7.9.5

