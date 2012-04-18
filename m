Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2DRADP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:03:15 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:46526 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753719Ab2DRADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:03:12 -0400
Message-ID: <4F8E04E6.60005@xenotime.net>
Date: Tue, 17 Apr 2012 17:03:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] spi: fix spi.h kernel-doc warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warning in spi.h (copy/pasto):

Warning(include/linux/spi/spi.h:365): No description found for parameter 'unprepare_transfer_hardware'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 include/linux/spi/spi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-34-rc3.orig/include/linux/spi/spi.h
+++ lnx-34-rc3/include/linux/spi/spi.h
@@ -254,7 +254,7 @@ static inline void spi_unregister_driver
  *	driver is finished with this message, it must call
  *	spi_finalize_current_message() so the subsystem can issue the next
  *	transfer
- * @prepare_transfer_hardware: there are currently no more messages on the
+ * @unprepare_transfer_hardware: there are currently no more messages on the
  *	queue so the subsystem notifies the driver that it may relax the
  *	hardware by issuing this call
  *
