Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab1GWARU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 20:17:20 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:37160 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756324Ab1GWARL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 20:17:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NXDhLMwFFC2MgR3d5HA+3hsUstTbxqrt6cA3mafsJVVXHK5wqLdJB9X4Mkt9+P3ds+wnN5ei21HI4vi0dkMqH/4+3hLFaDeCpclMXvA3tdKiOsApHovPu8Tbgben1QvF;
Date: Fri, 22 Jul 2011 17:17:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Hemanth V <hemanthv@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH] mfd: twl6030-pwm.c needs MODULE_LICENSE
Message-Id: <20110722171708.370b2cf5.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

twl6030_pwm: module license 'unspecified' taints kernel.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Hemanth V <hemanthv@ti.com>
---
 drivers/mfd/twl6030-pwm.c |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-30-rc7.orig/drivers/mfd/twl6030-pwm.c
+++ lnx-30-rc7/drivers/mfd/twl6030-pwm.c
@@ -161,3 +161,5 @@ void pwm_free(struct pwm_device *pwm)
 	kfree(pwm);
 }
 EXPORT_SYMBOL(pwm_free);
+
+MODULE_LICENSE("GPL");
