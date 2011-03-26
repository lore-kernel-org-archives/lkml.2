Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab1CZBSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:18:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45023 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755596Ab1CZBSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:18:38 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/Qf+ppcLHQb4WvNUsJ6nDPMQbRovEa1nNO52yjrh
	2kNR1KAeINhc9Q
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 06/27] staging/dt3155v4l: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:17:55 +0100
Message-Id: <1301102296-15565-7-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110314224746.GA21100@kroah.com>
References: <20110314224746.GA21100@kroah.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a very common spelling mistake in
drivers/staging/dt3155v4l.

WRONG -> RIGHT
writting -> writing

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/dt3155v4l/dt3155v4l.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
index 15d7efe..52a0e6e 100644
--- a/drivers/staging/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c
@@ -122,7 +122,7 @@ read_i2c_reg(void __iomem *addr, u8 index, u8 *data)
  *
  * returns:	zero on success or error code
  *
- * This function starts writting the specified (by index) register
+ * This function starts writing the specified (by index) register
  * and busy waits for the process to finish.
  */
 static int
@@ -155,7 +155,7 @@ write_i2c_reg(void __iomem *addr, u8 index, u8 data)
  * @index:	index (internal address) of register to read
  * @data:	data to be written
  *
- * This function starts writting the specified (by index) register
+ * This function starts writing the specified (by index) register
  * and then returns.
  */
 static void write_i2c_reg_nowait(void __iomem *addr, u8 index, u8 data)
@@ -173,7 +173,7 @@ static void write_i2c_reg_nowait(void __iomem *addr, u8 index, u8 data)
  *
  * returns:	zero on success or error code
  *
- * This function waits reading/writting to finish.
+ * This function waits reading/writing to finish.
  */
 static int wait_i2c_reg(void __iomem *addr)
 {
-- 
1.7.3.4

