Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab0IMDv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:51:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35778 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0IMDv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:51:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wdtAbh+l62DUjC/ZpFRZWL/Skwlb5lLLU4ElTLNi6qy+df8E0V04V6BzlRCRhd2n0J
         P83ODRWIkO3af9OKneW6o2hgLu7XMH27MkXpjNT0esv47PjVZ/XEbG0x/fOtpuezWeDG
         vZiYav45QeRur6EzwAxkLrkx/x+qXvRxzZkJE=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: eric.y.miao@gmail.com, marek.vasut@gmail.com, haojian.zhuang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        markb@marvell.com
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v2 0/3] ARM: pxa168: Added Teton BGA Board Support
Date: Sun, 12 Sep 2010 23:51:33 -0400
Message-Id: <1284349896-14545-1-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Support for Teton BGA Board
2) Keypad support for Teton BG
3) RTC support

Version 2:
1) Added information to MAINTAINERS
2) Added Authorship information
3) Added teton_bga.h in the board support patch
4) Added ALARM interrupt support for RTC

Patched on top of Eric Miao's tree commit 5df3afbca20235ff8b3d33bd0d26a0d47b989a30

Mark F. Brown (3):
  ARM: pxa168: added support for Teton BGA platform
  ARM: pxa168/teton bga: added keypad support
  ARM: pxa168/teton bga: add board support for i2c and rtc-ds1337

 MAINTAINERS                                |    5 ++
 arch/arm/mach-mmp/Kconfig                  |    7 ++
 arch/arm/mach-mmp/Makefile                 |    1 +
 arch/arm/mach-mmp/include/mach/teton_bga.h |   27 ++++++++
 arch/arm/mach-mmp/teton_bga.c              |   90 ++++++++++++++++++++++++++++
 5 files changed, 130 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-mmp/include/mach/teton_bga.h
 create mode 100644 arch/arm/mach-mmp/teton_bga.c

