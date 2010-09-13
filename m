Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0IMK2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:28:41 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:56655 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0IMK2k convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Mon, 13 Sep 2010 06:28:40 -0400
Message-Id: <4C8E18F30200007800015AFA@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 13 Sep 2010 11:28:35 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <fenghua.yu@intel.com>, <khali@linux-fr.org>
Cc: <r.marek@assembler.cz>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/hwmon: cosmetic cleanup for coretemp
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"break" after "return" is at best bogus (good compilers even warn about
the "break" being unreachable).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Rudolf Marek <r.marek@assembler.cz>

---
 drivers/hwmon/coretemp.c |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.36-rc4/drivers/hwmon/coretemp.c	2010-09-13 08:45:02.000000000 +0200
+++ 2.6.36-rc4-x86-coretemp-cosmetic/drivers/hwmon/coretemp.c	2010-09-03 17:54:14.000000000 +0200
@@ -279,11 +279,9 @@ static int __devinit get_tjmax(struct cp
 	case 0x1a:
 		dev_warn(dev, "TjMax is assumed as 100 C!\n");
 		return 100000;
-		break;
 	case 0x17:
 	case 0x1c:		/* Atom CPUs */
 		return adjust_tjmax(c, id, dev);
-		break;
 	default:
 		dev_warn(dev, "CPU (model=0x%x) is not supported yet,"
 			" using default TjMax of 100C.\n", c->x86_model);



