Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1B1G2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:28:31 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:64984 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1B1G2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:28:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MjS8OPN8QMVw72PgZD0r10advtdSs8nBXrjxNgNZQPBCEnTJewShALqjxLSE+Cbl4J
         CeL4NcTCdfTdN3vSYTCBq8HW6vAfcSOCazC4RP3zNQbvHbJc+UsjBLLSWPJjHhUpZKMX
         Mczwbty4Cis0+K+x73wh7BsHfmI0dJlnAqAVE=
Subject: [PATCH 1/3] mfd: mc13xxx-core: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain
Date: Mon, 28 Feb 2011 14:32:15 +0800
Message-Id: <1298874735.5562.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.
After adding the MODULE_DEVICE_TABLE, below entries will be added to
modules.alias:
alias spi:mc13892 mc13xxx_core
alias spi:mc13783 mc13xxx_core

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/mc13xxx-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index b9fcaf0..c300560 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -811,6 +811,7 @@ static const struct spi_device_id mc13xxx_device_id[] = {
 		/* sentinel */
 	}
 };
+MODULE_DEVICE_TABLE(spi, mc13xxx_device_id);
 
 static struct spi_driver mc13xxx_driver = {
 	.id_table = mc13xxx_device_id,
-- 
1.7.2



