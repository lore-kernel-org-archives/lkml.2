Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab1JTJdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:33:17 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:50934 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab1JTJdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:33:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: linus.ml.walleij@gmail.com, zdevai@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        lm-sensors@lm-sensors.org, guenter.roeck@ericsson.com,
        khali@linux-fr.org, thomas.petazzoni@free-electrons.com,
        maxime.ripard@free-electrons.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 1/6] IIO: core: add datasheet_name to chan_spec
Date: Thu, 20 Oct 2011 10:33:02 +0100
Message-Id: <1319103187-27791-2-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1319103187-27791-1-git-send-email-jic23@cam.ac.uk>
References: <1319103187-27791-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows for matching against the name given
on a datasheet, however silly/inconsistent it might
be.

Useful for in kernel interfaces.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 include/linux/iio/iio.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 8066c8a..beedc5c 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -128,6 +128,7 @@ struct iio_chan_spec {
 	} scan_type;
 	long                    info_mask;
 	char			*extend_name;
+	const char		*datasheet_name;
 	unsigned		processed_val:1;
 	unsigned		modified:1;
 	unsigned		indexed:1;
-- 
1.7.7

