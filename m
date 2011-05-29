Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab1E2OTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 10:19:30 -0400
Received: from t111.niisi.ras.ru ([193.232.173.111]:51521 "EHLO
	t111.niisi.ras.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1E2OT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 10:19:29 -0400
X-Greylist: delayed 1357 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 May 2011 10:19:28 EDT
From: Antony Pavlov <antony@niisi.msk.ru>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antony Pavlov <antony@niisi.msk.ru>
Subject: [PATCH] drivers/tty/serial/8250_pci.c: fix warning
Date: Sun, 29 May 2011 18:12:26 +0400
Message-Id: <1306678346-32045-1-git-send-email-antony@niisi.msk.ru>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110525103740.f8917fd8.sfr@canb.auug.org.au>
References: <20110525103740.f8917fd8.sfr@canb.auug.org.au>
X-Antivirus: Dr.Web (R) for Mail Servers on t111.niisi.ras.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Antony Pavlov <antony@niisi.msk.ru>
---
 drivers/tty/serial/8250_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 4b4968a..78e98a5 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -973,7 +973,7 @@ ce4100_serial_setup(struct serial_private *priv,
 
 static int
 pci_omegapci_setup(struct serial_private *priv,
-		      struct pciserial_board *board,
+		      const struct pciserial_board *board,
 		      struct uart_port *port, int idx)
 {
 	return setup_port(priv, port, 2, idx * 8, 0);
-- 
1.7.1

