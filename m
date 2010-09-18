Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0IRTGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:06:41 -0400
Received: from kroah.org ([198.145.64.141]:51910 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab0IRTC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:29 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:02 2010
Message-Id: <20100918190002.851564590@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [117/123] apm_power: Add missing break statement
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=apm_power-add-missing-break-statement.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <cbouatmailru@gmail.com>

commit 1d220334d6a8a711149234dc5f98d34ae02226b8 upstream.

The missing break statement causes wrong capacity calculation for
batteries that report energy.

Reported-by: d binderman <dcb314@hotmail.com>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/power/apm_power.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -233,6 +233,7 @@ static int calculate_capacity(enum apm_s
 		empty_design_prop = POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN;
 		now_prop = POWER_SUPPLY_PROP_ENERGY_NOW;
 		avg_prop = POWER_SUPPLY_PROP_ENERGY_AVG;
+		break;
 	case SOURCE_VOLTAGE:
 		full_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX;
 		empty_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN;


