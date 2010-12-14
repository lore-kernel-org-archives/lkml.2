Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0LNKJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:09:22 -0500
Received: from smtp.nokia.com ([147.243.1.48]:52265 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab0LNKJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:09:19 -0500
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Andras Domokos <andras.domokos@nokia.com>
Subject: [RFC PATCHv4 7/7] HSI: hsi_char: Update ioctl-number.txt
Date: Tue, 14 Dec 2010 12:09:43 +0200
Message-Id: <1292321383-30200-8-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andras Domokos <andras.domokos@nokia.com>

Added ioctl range for HSI char devices to the documentation

Signed-off-by: Andras Domokos <andras.domokos@nokia.com>
Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 63ffd78..955bf5e 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -225,6 +225,7 @@ Code  Seq#(hex)	Include File		Comments
 'j'	00-3F	linux/joystick.h
 'k'	00-0F	linux/spi/spidev.h	conflict!
 'k'	00-05	video/kyro.h		conflict!
+'k'	10-17	linux/hsi/hsi_char.h	HSI character device
 'l'	00-3F	linux/tcfs_fs.h		transparent cryptographic file system
 					<http://web.archive.org/web/*/http://mikonos.dia.unisa.it/tcfs>
 'l'	40-7F	linux/udf_fs_i.h	in development:
-- 
1.7.1

