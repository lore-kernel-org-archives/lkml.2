Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab0EJUHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:07:19 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33596 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab0EJUHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CVo/adHcfSyG5yw/xIAV1FQJ+ojw4k4qIzVhUyarR6UkFZg509l3SvMfUqfX0SNZRm
         N5H67IMSacMWLJq9pQO9dkERPt9TxBJJY532GT8Zh2z6JeOlkLWAIUxdAocoBPsVBnov
         tHg0HmoFNLXdNwjXVS5ZtL0M7JZZxDzGOq7nc=
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: paulius.zaleckas@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk
Subject: [PATCH 0/4] ARM: Gemini: board/maintainer updates
Date: Mon, 10 May 2010 22:06:57 +0200
Message-Id: <1273522021-14436-1-git-send-email-ulli.kroll@googlemail.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello to all,

Here are some board updates for the Gemini SoC

The sources are from the openwrt-team and Janos Laube.
I've removed only parts that are not in Linus' tree, mainly drivers for 
ethernet, usb and other stuff.

The the driver for watchdog and rtc are ready to ship.
These will be added on the next round, avoiding some chicken and egg 
problem ;-)

Patches 1-3 _must_ be applied in order, due Kconfig and Makefile changes.

Ulli

Hans Ulli Kroll (1):
      MAINTAINERS: update for ARM/Gemini

Imre Kaloz (2):
      ARM: Gemini: add support for Wiligear WBD-111
      ARM: Gemini: add support for Wiliboard WBD-222

Janos Laube (1):
      ARM: Gemini: add support for Raidsonic IB4220

 MAINTAINERS                           |   11 ++-
 arch/arm/mach-gemini/Kconfig          |   21 +++++
 arch/arm/mach-gemini/Makefile         |    3 +
 arch/arm/mach-gemini/board-nas4220b.c |  111 +++++++++++++++++++++++++
 arch/arm/mach-gemini/board-wbd111.c   |  143 +++++++++++++++++++++++++++++++++
 arch/arm/mach-gemini/board-wbd222.c   |  143 +++++++++++++++++++++++++++++++++
 6 files changed, 427 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/mach-gemini/board-nas4220b.c
 create mode 100644 arch/arm/mach-gemini/board-wbd111.c
 create mode 100644 arch/arm/mach-gemini/board-wbd222.c

