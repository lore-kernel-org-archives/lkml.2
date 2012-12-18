Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2LRVHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:07:38 -0500
Received: from [207.46.163.24] ([207.46.163.24]:7707 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751345Ab2LRVHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:07:35 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MF8VY2-02-11R-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, Doug Thompson <dougthompson@xmission.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V2 0/2] MCE, AMD: MCE decoding support for AMD Family 16h
Date: Tue, 18 Dec 2012 15:06:09 -0600
Message-ID: <1355864771-13839-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset enables MCE decoding support for AMD Family 16h
processors.

Changes in V2:
* Changed if/else style and pr_cont usage per feedback from:
  https://lkml.org/lkml/2012/12/17/365

* Merged f14h and f16h mc0 and mc2 decoding into common function per
  feedback from: https://lkml.org/lkml/2012/12/18/269

* Fixed typo in INT_ERROR decoding.

Jacob Shin (2):
  MCE, AMD: Make MC2 decoding part of amd_decoder_ops as well
  MCE, AMD: MCE decoding support for AMD Family 16h

 drivers/edac/mce_amd.c |  139 +++++++++++++++++++++++++++++++++++-------------
 drivers/edac/mce_amd.h |    4 ++
 2 files changed, 105 insertions(+), 38 deletions(-)

-- 
1.7.9.5


