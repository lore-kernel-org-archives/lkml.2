Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab0HCRhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:37:01 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:15580 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab0HCRg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:36:59 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "'gregkh@suse.de'" <gregkh@suse.de>
Subject: [PATCH 4/6] staging: hv: Removed TODO for VMBUS, it mirrors HYPER-V
 behavior to closely
Thread-Topic: [PATCH 4/6] staging: hv: Removed TODO for VMBUS, it mirrors
 HYPER-V behavior to closely
Thread-Index: AcszLQid728lvz1rQMimYb0ghjtRrQ==
Date: Tue, 3 Aug 2010 17:31:54 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FD1D2F@TK5EX14MBXC114.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com>

Removed TODO for VMBUS, it mirrors HYPER-V behaviour to closely and does not really share any 
usable functionality of the Linux kernel facilities. There is not really an easy way to combine functionality.

Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com>

---
 drivers/staging/hv/TODO |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/TODO b/drivers/staging/hv/TODO index 66a89c8..8ca2947 100644
--- a/drivers/staging/hv/TODO
+++ b/drivers/staging/hv/TODO
@@ -4,8 +4,6 @@ TODO:
 	  driver model
 	- convert vmbus driver interface function pointer tables
           to constant, a.k.a vmbus_ops
-	- see if the vmbus can be merged with the other virtual busses
-	  in the kernel
 	- audit the network driver
 	  - checking for carrier inside open is wrong, network device API
             confusion??
--
1.6.0.2

