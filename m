Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1CAJUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:20:43 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58847 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab1CAJUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 04:20:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V1a6gXcYl4eY+q5lFJ+qJsLyTlczGuh3YYx16K3EQdXjg7hRAMSf8c+k4jyU7z4ITU
         tKkItOMuDV5Qt+kc9JTsOqbfcJTclH6HtRfmFvj2y+UDFxjutJm2i1k8m0qStZb5fLY0
         HPJ6TEnroFdMxvZZ34ffM4EOTAbf8+HjzIJc0=
Subject: [PATCH 3/3] power: z2_battery: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
In-Reply-To: <1298971353.17825.1.camel@mola>
References: <1298971353.17825.1.camel@mola>
Content-Type: text/plain
Date: Tue, 01 Mar 2011 17:24:34 +0800
Message-Id: <1298971474.17825.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.
After adding the MODULE_DEVICE_TABLE, below entry will be added to
modules.alias:
alias i2c:aer915 z2_battery

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/z2_battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/z2_battery.c b/drivers/power/z2_battery.c
index e5ed52d..81304c0 100644
--- a/drivers/power/z2_battery.c
+++ b/drivers/power/z2_battery.c
@@ -293,6 +293,7 @@ static const struct i2c_device_id z2_batt_id[] = {
 	{ "aer915", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, z2_batt_id);
 
 static struct i2c_driver z2_batt_driver = {
 	.driver	= {
-- 
1.7.2



