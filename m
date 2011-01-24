Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1AXQgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:36:37 -0500
Received: from fb1.tech.numericable.fr ([82.216.111.51]:56401 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1AXQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:36:35 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 00/14] eeepc-wmi updates
Date: Mon, 24 Jan 2011 17:23:44 +0100
Message-Id: <1295886238-15961-1-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentin.chary@gmail.com>

Hi Matthew,

Thanks to a generous donator, I was able to buy an Eeepc 1000H. It really
easier to make patch when you have the hardware :).

These patches add some features to eeepc-wmi that where already available in
eeepc-laptop (wimax, camera, cardr, wlan hotplug) and some new features
(backlight power).

You may want to take a look at "eeepc-wmi: add hotplug code for Eeepc 1000H"
and "eeepc-wmi: serialize access to wmi method" since you wrote the original
patch for eeepc-laptop.

It's probably way to late for 2.6.38, so let's queue them for 2.6.39. Anyway
if disitribution want to backport some patches, it should be easy to do with
any kernel >= 2.6.34.

Thanks,

Corentin Chary (14):
  eeepc-wmi: reorder keymap
  eeepc-wmi: add wlan key found on 1015P
  eeepc-wmi: add hotplug code for Eeepc 1000H
  eeepc-wmi: serialize access to wmi method
  eeepc-wmi: return proper error code in eeepc_rfkill_set()
  eeepc-wmi: add an helper using simple return codes
  eeepc-wmi: add hibernate/resume callbacks
  eeepc-wmi: switch to platform_create_bundle()
  eeepc-wmi: reorder defines
  eeepc-wmi: use the presence bit correctly
  eeepc-wmi: add camera and card reader support
  eeepc-wmi: add wimax support
  eeepc-wmi: set the right key code for 0xe9
  eeepc-wmi: support backlight power (bl_power) attribute

 Documentation/ABI/testing/sysfs-platform-eeepc-wmi |   14 +
 drivers/platform/x86/eeepc-wmi.c                   |  744 ++++++++++++++++----
 2 files changed, 633 insertions(+), 125 deletions(-)

-- 
1.7.3.4

