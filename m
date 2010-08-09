Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab0HIXRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 19:17:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52968 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab0HIXRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 19:17:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=Ii0UjC1LE6OX8hA0mfcPOjdW+4igvQg6Aj4X/r8NUIZ1V8P1+fvrreXkfHMhiN+JGl
         QXlh3wiNjGLVIGyidUx0dU+lYEcZJ5aqaLENd5uvHuSV4Iua+34GoJ5LP2Y9/0uvnwtw
         OtUMRCjEi4XHTDd+2Im4dYq2esMinCrD8hzuU=
From: wellsk40@gmail.com
To: rtc-linux@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: RTC: LPC32xx: Introduce RTC driver for the LPC32xx
Date: Mon,  9 Aug 2010 09:17:28 -0700
Message-Id: <1281370650-29520-1-git-send-email-wellsk40@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the LPC32xx built-in RTC. This is
a persistent RTC with alarm on it's own power domain and a
dedicated oscillator. UIE emulation is used for *_UIE_* ioctls.

