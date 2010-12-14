Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148Ab0LNPJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:09:55 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:45047 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab0LNPJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:09:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZhUB8qZ4wWDvE5FHbTfl1I2db8zOSXFjr91Aum9Q9iVinTlywQzJ9sTnVtn/1Lhlbp
         ecg6VNAJ3SE5qmUHgHkV0BF2Tk4PDSdYRtYgxiAXVuVUsmNcZRF0SA0GtFuYOu/RaOJ9
         Z78AOpOI5gKzGb0PhHlOwsOq2XkLsUVRj03ow=
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH 0/2] ARM: Gemini: add RTC support for Gemini SoC 
Date: Tue, 14 Dec 2010 16:08:25 +0100
Message-Id: <1292339307-14336-1-git-send-email-ulli.kroll@googlemail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the driver for the rtc chip on the Gemini SoC

I divided this patch into two parts.
One for the core rtc-driver in /drivers/rtc
and one for the needed platform bindings in /arch/arm/mach-gemini

 MAINTAINERS                           |    1 +
 arch/arm/mach-gemini/board-nas4220b.c |    1 +
 arch/arm/mach-gemini/board-rut1xx.c   |    1 +
 arch/arm/mach-gemini/board-wbd111.c   |    1 +
 arch/arm/mach-gemini/board-wbd222.c   |    1 +
 arch/arm/mach-gemini/common.h         |    1 +
 arch/arm/mach-gemini/devices.c        |   26 ++++
 drivers/rtc/Kconfig                   |    9 ++
 drivers/rtc/Makefile                  |    1 +
 drivers/rtc/rtc-gemini.c              |  206 +++++++++++++++++++++++++++++++++
 10 files changed, 248 insertions(+), 0 deletions(-)


