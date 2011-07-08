Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1GHIyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:54:54 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40029 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab1GHIyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:54:50 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/12] Staging: gma500: typo in array initialization
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:45:19 +0100
Message-ID: <20110708084517.19581.73419.stgit@localhost.localdomain>
In-Reply-To: <20110708084053.19581.81711.stgit@localhost.localdomain>
References: <20110708084053.19581.81711.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

There is a comma missing here between the strings so they were
concatenated by mistake.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mdfld_dsi_pkg_sender.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/mdfld_dsi_pkg_sender.c b/drivers/staging/gma500/mdfld_dsi_pkg_sender.c
index 9198aa8..9b543eb 100644
--- a/drivers/staging/gma500/mdfld_dsi_pkg_sender.c
+++ b/drivers/staging/gma500/mdfld_dsi_pkg_sender.c
@@ -62,7 +62,7 @@ static const char * const dsi_errors[] = {
 	"RX Prot Violation",
 	"HS Generic Write FIFO Full",
 	"LP Generic Write FIFO Full",
-	"Generic Read Data Avail"
+	"Generic Read Data Avail",
 	"Special Packet Sent",
 	"Tearing Effect",
 };

