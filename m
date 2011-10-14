Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1JNJI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:08:26 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:51012 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab1JNJIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:08:25 -0400
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Anisse Astier <anisse@astier.eu>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Ross <andy.ross@windriver.com>,
        Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 0/8] Pegatron Lucid series for asus-laptop
Date: Fri, 14 Oct 2011 11:13:34 +0200
Message-Id: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This is a series of patch that were staging in my tree for
way too long. I hope they will make it to the next merge window.
Thanks,

Andy Ross (4):
  asus-laptop: Platform detection for Pegatron Lucid
  asus-laptop: Pegatron Lucid ALS sensor
  asus-laptop: allow boot time control of Pegatron ALS sensor
  asus-laptop: Pegatron Lucid accelerometer

Anisse Astier (2):
  asus-laptop: pega_accel - Report accelerometer orientation change
    through udev
  asus-laptop: Add rfkill support for Pegatron Lucid tablet

Corentin Chary (2):
  asus-laptop: hide leds on Pegatron Lucid
  asus-laptop: fix module description

 drivers/platform/x86/Kconfig       |   19 +-
 drivers/platform/x86/asus-laptop.c |  366 ++++++++++++++++++++++++++++++++++--
 2 files changed, 363 insertions(+), 22 deletions(-)

-- 
1.7.3.4

