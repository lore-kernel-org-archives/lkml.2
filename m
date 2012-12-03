Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab2LCOz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:55:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43601 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932115Ab2LCOfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:51 -0500
Message-Id: <20121203143200.474685476@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:33:15 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [ 89/89] intel_idle: enable IVB Xeon support
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 23795e580cad5d6b73d47d51b9074ce3e58bf334 upstream.

IVB Xeon currently shares the same parameters IVB client.

For 3.2, add model number to the switch in intel_idle_probe(), as
there is no device ID table.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/idle/intel_idle.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -419,6 +419,7 @@ static int intel_idle_probe(void)
 		break;
 
 	case 0x3A:	/* IVB */
+	case 0x3E:	/* IVB Xeon */
 		cpuidle_state_table = ivb_cstates;
 		break;
 


