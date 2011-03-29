Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1C2Gc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:32:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42041 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1C2Gc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=vA/c68OdQ+JP2GYD1ELxCSUn6maua04MkbqfYp20+pqnmLk5MW4XtAwn+HQ6HP7qKO
         jrdPET+7VGZZXTMAReSJULJRnWcWfTUZWiCoe0/THHkbg43c4IveL5BDrJzQyS++EsXR
         6Gb6lSXEDKjWw3iWKAWW5UOjnNi5zYShTj3i8=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: ben-linux@fluff.org
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net, esta1ien@gmail.com,
        buserror@gmail.com, Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 0/4] s3c2440: mini2440: Add missing code parts to be fully working with latest kernel.
Date: Tue, 29 Mar 2011 08:32:39 +0200
Message-Id: <1301380363-3282-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch add new LCD panels with which was board produced. Also add touchscreen
support. Enabling LCD backlight during early booting stage also added.

Some code parts are collected or inspired from other code (authors are in CC).

Marek Belisko (4):
  s3c2440: mini2440: Add support for new LCD panels.
  s3c2440: mini2440: Add touchscreen support for mini2440.
  s3c2440: mini2440: Select touchscreen by default.
  s3c2440: mini2440: Enable the backlight LED earlier at boot time.

 arch/arm/mach-s3c2410/include/mach/leds-gpio.h |    1 +
 arch/arm/mach-s3c2440/Kconfig                  |    1 +
 arch/arm/mach-s3c2440/mach-mini2440.c          |   55 +++++++++++++++++++++++-
 drivers/leds/leds-s3c24xx.c                    |    6 ++-
 4 files changed, 60 insertions(+), 3 deletions(-)

