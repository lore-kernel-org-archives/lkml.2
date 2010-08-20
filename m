Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab0HTJAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:00:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0HTJAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:00:48 -0400
Message-ID: <4C6E4539.4000703@redhat.com>
Date: Fri, 20 Aug 2010 17:04:57 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Amit Salecha <amit.salecha@qlogic.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dhananjay Phadke <dhananjay.phadke@qlogic.com>,
        Narender Kumar <narender.kumar@qlogic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC Patch] netxen: remove firmware exports
References: <20100818095908.6606.56224.sendpatchset@localhost.localdomain> <99737F4847ED0A48AECC9F4A1974A4B80F86E69208@MNEXMB2.qlogic.org>
In-Reply-To: <99737F4847ED0A48AECC9F4A1974A4B80F86E69208@MNEXMB2.qlogic.org>
Content-Type: multipart/mixed;
 boundary="------------060504070900000505000003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060504070900000505000003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/19/10 17:12, Amit Salecha wrote:
> NX_UNIFIED_ROMIMAGE_NAME(phanfw.bin) is already submitted and we won't submit any other fw files.

Based on above, remove the rest firmware exports.

Thanks!

-- 
Signed-off-by: WANG Cong <amwang@redhat.com>

--------------060504070900000505000003
Content-Type: text/x-patch;
 name="drivers-net-netxen-remove-firmwares.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="drivers-net-netxen-remove-firmwares.diff"

diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index fd86e18..2fedc3b 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -41,9 +41,6 @@
 MODULE_DESCRIPTION("QLogic/NetXen (1/10) GbE Converged Ethernet Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(NETXEN_NIC_LINUX_VERSIONID);
-MODULE_FIRMWARE(NX_P2_MN_ROMIMAGE_NAME);
-MODULE_FIRMWARE(NX_P3_CT_ROMIMAGE_NAME);
-MODULE_FIRMWARE(NX_P3_MN_ROMIMAGE_NAME);
 MODULE_FIRMWARE(NX_UNIFIED_ROMIMAGE_NAME);
 
 char netxen_nic_driver_name[] = "netxen_nic";

--------------060504070900000505000003--
