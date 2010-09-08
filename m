Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0IHC5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:57:02 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62189 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab0IHC47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wnkfWfvrmHdKD2kv4UsdTuP3MRDSunVKNsNIZWlt3fJXQvTjAvK8CFfphIQ6UpqcTM
         XLbBps9NzXdJH9BuF4C2LjdWxyB4EvPhTDzmzZUbKqVHJ/ZjgmUR1BkkO+7mn6+h2G1v
         v2We5qVLS+fwhxcNsf1wjpHAzNY4KGzxwlvE8=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH 0/3] ARM: pxa168: Added Teton BGA Board Support
Date: Tue,  7 Sep 2010 22:56:44 -0400
Message-Id: <1283914607-10570-1-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Support for Teton BGA Board
2) Keypad support for Teton BGA
3) RTC support

Patched on top of Eric Miao's tree commit 5df3afbca20235ff8b3d33bd0d26a0d47b989a30

Mark F. Brown (3):
  ARM: pxa168: added support for Teton BGA platform
  ARM: pxa168/teton bga: added keypad support
  ARM: pxa168/teton bga: add board support for i2c and rtc-ds1337

 arch/arm/mach-mmp/Kconfig     |    7 ++++
 arch/arm/mach-mmp/Makefile    |    1 +
 arch/arm/mach-mmp/teton_bga.c |   81 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-mmp/teton_bga.c

