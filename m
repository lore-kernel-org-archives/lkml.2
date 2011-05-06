Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1EFA56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:57:58 -0400
Received: from kroah.org ([198.145.64.141]:36745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab1EFAYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:09 2011
Message-Id: <20110506002209.557408598@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [044/143] myri10ge: declare MODULE_FIRMWARE
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit b9721d5a2fa00ad979c19a9511d43d2664d5381c upstream.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/myri10ge/myri10ge.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -264,6 +264,10 @@ static char *myri10ge_fw_unaligned = "my
 static char *myri10ge_fw_aligned = "myri10ge_eth_z8e.dat";
 static char *myri10ge_fw_rss_unaligned = "myri10ge_rss_ethp_z8e.dat";
 static char *myri10ge_fw_rss_aligned = "myri10ge_rss_eth_z8e.dat";
+MODULE_FIRMWARE("myri10ge_ethp_z8e.dat");
+MODULE_FIRMWARE("myri10ge_eth_z8e.dat");
+MODULE_FIRMWARE("myri10ge_rss_ethp_z8e.dat");
+MODULE_FIRMWARE("myri10ge_rss_eth_z8e.dat");
 
 static char *myri10ge_fw_name = NULL;
 module_param(myri10ge_fw_name, charp, S_IRUGO | S_IWUSR);


