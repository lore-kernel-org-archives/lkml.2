Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286Ab2G0EC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 00:02:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39274 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2G0EC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 00:02:56 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: gregkh@linuxfoundation.org, ccross@android.com, hmh@hmh.eng.br,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: [PATCH 0/3] add new API to sysfs and device core code 
Date: Fri, 27 Jul 2012 12:02:40 +0800
Message-Id: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Send out a uevent when create file in sysfs, which is required by userspace
application such udev in Android

Bryan Wu (3):
  sysfs: introduce a sysfs_create_file_uevent new API
  drivers: add a new device_create_file_uevent API
  ledtrig-timer: convert to use device_create_file_uevent API

 drivers/base/core.c          | 19 +++++++++++++++++++
 drivers/leds/ledtrig-timer.c |  6 ++++--
 fs/sysfs/file.c              | 28 ++++++++++++++++++++++++++++
 include/linux/device.h       |  4 ++++
 include/linux/sysfs.h        | 13 +++++++++++++
 5 files changed, 68 insertions(+), 2 deletions(-)

-- 
1.7.11.1

