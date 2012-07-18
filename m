Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2GRL6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:58:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42340 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab2GRL6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:58:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120715133530.1ffc3f36@endymion.delvare>
References: <1342172455-8530-1-git-send-email-amaury.decreme@gmail.com>
 <CAErSpo5-ou3vjmHgjiOOd57PvWg_hez80U0k3AX_ydjb0pikvQ@mail.gmail.com> <20120715133530.1ffc3f36@endymion.delvare>
From: =?UTF-8?Q?Amaury_Decr=C3=AAme?= <amaury.decreme@gmail.com>
Date: Wed, 18 Jul 2012 13:57:54 +0200
Message-ID: <CAPXEm70iiU-OQ4DbmBaPzk-WTxBLzvEPSTrRwcn073q9DFs08A@mail.gmail.com>
Subject: Re: [PATCH] i2c: sis964: bus driver
To: Jean Delvare <khali@linux-fr.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-i2c@vger.kernel.org,
        amalysh@web.de, nelson@sis.com, ben-linux@fluff.org,
        w.sang@pengutronix.de, rob@landley.net, jeffrey.t.kirsher@intel.com,
        akpm@linux-foundation.org, davem@davemloft.net, joe@perches.com,
        ralf@linux-mips.org, dirk.brandewie@gmail.com,
        jayachandranc@netlogicmicro.com, Xiangzhen.Ye@csr.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, hi3766691@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


For the v2 of this patch, I will remove the modifications on
include/linux/pci_ids.h

 include/linux/pci_ids.h             |    1 +
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index ab741b0..0ffc982 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -699,6 +699,7 @@
 #define PCI_DEVICE_ID_SI_961           0x0961
 #define PCI_DEVICE_ID_SI_962           0x0962
 #define PCI_DEVICE_ID_SI_963           0x0963
+#define PCI_DEVICE_ID_SI_964           0x0964
 #define PCI_DEVICE_ID_SI_965           0x0965
 #define PCI_DEVICE_ID_SI_966           0x0966
 #define PCI_DEVICE_ID_SI_968           0x0968


And will add this to drivers/i2c/busses/i2c-sis964.c directly as
i2c-sis964 will be the only file needing this define
+#define PCI_DEVICE_ID_SI_964           0x0964



Amaury Decrême
