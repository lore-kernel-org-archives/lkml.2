Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0LMJ75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:59:57 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34253 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0LMJ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:59:54 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH v3 0/6] ideapad: hotkey enablement
Date: Mon, 13 Dec 2010 17:59:44 +0800
Message-Id: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the enablement patches for hotkey events on ideapads and these patches
are made against current checkout of mainline kernel.

After last time posting on LKML, there are several feedback and these patches
are modified.

>From Dmitry Torokhov, squash the select INPUT_SPARSEKMAP patch and hotkey
enablement patch.
>From Corentin Chary, add documentation about the usage of sysfs node
>From Dave Hansen, change the platform node name from Ideapad to ideapad

These patches are available in the git repository at:
  git://kernel.ubuntu.com/ikepanhc/ideapad-laptop.git ideapad-laptop



Ike Panhc (6):
  ideapad: add platform driver for ideapad
  ideapad: let camera power control entry under platform driver
  ideapad: add hotkey support
  ideapad: add markups, unify comments and return result when init
  ideapad: pass ideapad_priv as argument (part 1)
  ideapad: pass ideapad_priv as argument (part 2)

 .../ABI/testing/sysfs-platform-ideapad-laptop      |    6 +
 drivers/platform/x86/Kconfig                       |    1 +
 drivers/platform/x86/ideapad-laptop.c              |  259 ++++++++++++++------
 3 files changed, 186 insertions(+), 80 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-ideapad-laptop

