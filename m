Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab1FVKSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:18:51 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:10700 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1FVKSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:18:49 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzz8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LN6SIX-02-27V-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
        <davidb@codeaurora.org>, <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] drivers/iommu/ relocations
Date: Wed, 22 Jun 2011 12:16:44 +0200
Message-ID: <1308737806-2658-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307742947-32118-1-git-send-email-ohad@wizery.com>
References: <1307742947-32118-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, I applied the patches to move forward with them. On-top I also put
two additional patches which are sent as a follow-up to this mail.

These changes are at 

	git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git

in the core branch.

Thanks,

	Joerg


