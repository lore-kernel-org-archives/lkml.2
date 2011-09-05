Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1IEO5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:57:22 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:52313
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754292Ab1IEO5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:57:17 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR21J8-01-GDZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Fixes for AMD-Vi
Date: Mon, 5 Sep 2011 16:56:59 +0200
Message-ID: <1315234621-26694-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are two small fixes for the AMD IOMMU driver. They fix a small
performance problem because of too many unnecessary completion-wait
commands and a dead-lock when a driver allocates more than 1GB of dma
address space.

Regards,

	Joerg


