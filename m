Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab2EGUaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:30:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18406 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab2EGUaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:21 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/21] PCI: Remove secondary/subordinate in struct ci_bus
Date: Mon,  7 May 2012 13:29:48 -0700
Message-Id: <1336422606-4244-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used anymore, so remove the duplicated secondary/subordinate.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/pci.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2b91da0..d588ef4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -427,8 +427,6 @@ struct pci_bus {
 
 	unsigned char	number;		/* bus number */
 	unsigned char	primary;	/* number of primary bridge */
-	unsigned char	secondary;	/* number of secondary bridge */
-	unsigned char	subordinate;	/* max number of subordinate buses */
 	unsigned char	max_bus_speed;	/* enum pci_bus_speed */
 	unsigned char	cur_bus_speed;	/* enum pci_bus_speed */
 
-- 
1.7.7

