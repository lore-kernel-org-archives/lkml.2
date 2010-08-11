Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0HKXGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:06:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51068 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab0HKXGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=edNLRyyfPXLm/DQHAHYINMuw3NYUHU5r/Y4N30ApsfSEDFXlKrRZs/b3SuScUEKvaZ
         TtzS30BO93SXm4j7luNY+asfm36XbHwPvE3pEi5T4lGDqJ4GL/ObfgFInJE48wKj0+M1
         9i1wffX7uF1PSD0GC6vArlMDzKJ3WMiOJ7DWM=
From: wellsk40@gmail.com
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: RTC: LPC32xx: Introduce RTC driver for the LPC32xx (v2)
Date: Wed, 11 Aug 2010 16:06:19 -0700
Message-Id: <1281567980-12792-1-git-send-email-wellsk40@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the LPC32xx built-in RTC. This is
a persistent RTC with alarm on it's own power domain and a
dedicated oscillator. UIE emulation is used for *_UIE_* ioctls.

v2 includes updates from the initial review of the RTC driver.

The patch can be pulled from:
	git://git.lpclinux.com/linux-2.6-lpc rtc-lpc32xx_v2

