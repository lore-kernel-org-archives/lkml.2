Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2DBRjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:39:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64424 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2DBRjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:39:44 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [3.4-rc1][Regression][intel] Resume from suspend to disk hangs on restoring backlight state
Date: Mon, 2 Apr 2012 19:39:39 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc1; KDE/4.7.4; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204021939.39603.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good: 3.3
Bad kernel: 3.4-rc1
Subsystem: power management/suspend/dri(intel)

When I resume from suspend to disk then system hangs on this screen:
http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/DSC_5479.jpg

It does not help SysRq keys. Only I can force power off by hold power button.

Dmesg:
http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/dmesg-3.4-rc1.txt

Config:
http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/config-3.4.0-rc1
-- 
Maciej Rutecki
http://www.mrutecki.pl
