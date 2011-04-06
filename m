Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1DFNBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:01:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55961 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab1DFNBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=PAWHTL5UHnzE5uh4NO8UTBIEzm0Qqm4BgElBG8G3J6UM+Hdyyis0L+lk9NtRmqX4av
         L7EmgZPg4maeVxV5+VCk1Lss0vPIDeKTJ2WGEeK1QI9YeUJDwi0L3U06rcnmupuaQpmK
         ZkXEtspQH/jk3srjZD+8wwD1CMjL9VsaroFtM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: ben-linux@fluff.org
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, esta1ien@gmail.com, buserror@gmail.com,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 0/4] s3c2440: mini2440: Add missing code parts to be fully working with latest kernel.
Date: Wed,  6 Apr 2011 15:01:33 +0200
Message-Id: <1302094897-18446-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes from v1 to v2: Replace original patch [4] with generic leds-gpio driver.

Patch add new LCD panels with which was board produced. Also add touchscreen
support. Enabling LCD backlight during early booting stage also added.

Some code parts are collected or inspired from other code (authors are in CC).

Marek Belisko (4):
  s3c2440: mini2440: Add support for new LCD panels.
  s3c2440: mini2440: Add touchscreen support for mini2440.
  s3c2440: mini2440: Select touchscreen by default.
  s3c2440: mini2440: Use leds-gpio driver for board leds handling.

 arch/arm/mach-s3c2440/Kconfig         |    1 +
 arch/arm/mach-s3c2440/mach-mini2440.c |  176 ++++++++++++++++++++-------------
 2 files changed, 107 insertions(+), 70 deletions(-)

