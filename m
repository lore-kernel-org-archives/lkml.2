Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1KGPor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:44:47 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43043 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1KGPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:44:44 -0500
From: Jonathan Cameron <jic23@kernel.org>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com, khali@linux-fr.org, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de, linus.walleij@linaro.org,
        lars@metafoo.de, maxime.ripard@free-electrons.com,
        lm-sensors@lm-sensors.org, thomas.petazzoni@free-electrons.com,
        zdevai@gmail.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 1/5] IIO: core: add datasheet_name to chan_spec
Date: Mon,  7 Nov 2011 15:44:37 +0000
Message-Id: <1320680681-5635-2-git-send-email-jic23@kernel.org>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1320680681-5635-1-git-send-email-jic23@kernel.org>
References: <1320680681-5635-1-git-send-email-jic23@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

This allows for matching against the name given
on a datasheet, however silly/inconsistent it might
be.

Useful for in kernel interfaces.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 include/linux/iio/iio.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 4367d82..36a50b2 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -122,6 +122,7 @@ struct iio_chan_spec {
 	} scan_type;
 	long                    info_mask;
 	char			*extend_name;
+	const char		*datasheet_name;
 	unsigned		processed_val:1;
 	unsigned		modified:1;
 	unsigned		indexed:1;
-- 
1.7.7.2

