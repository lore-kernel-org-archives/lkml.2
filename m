Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2KUMsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:48:25 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:52571
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149Ab2KUMsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:48:23 -0500
X-Forefront-Antispam-Report: CIP:157.56.241.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0810HT001.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1de0h1202h1d1ah1d2ahzzz2fh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sachin.kamat@linaro.org>
Subject: [V2 PATCH 0/3] staging : ozwpan: Remove NULL pointer check
Date: Wed, 21 Nov 2012 12:46:14 +0000
Message-ID: <1353501977-6585-1-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20121120163513.GC4990@kroah.com>
References: <20121120163513.GC4990@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes NULL pointer check before kfree

Rupesh Gujare (3):
  staging: ozwpan: Remove redundant null check before kfree in ozpd.c
  staging: ozwpan: Remove redundant null check before kfree in
    ozproto.c
  staging: ozwpan: Remove redundant null check before kfree in ozhcd.c

 drivers/staging/ozwpan/ozhcd.c   |    6 +++---
 drivers/staging/ozwpan/ozpd.c    |    6 +++---
 drivers/staging/ozwpan/ozproto.c |    6 ++----
 3 files changed, 8 insertions(+), 10 deletions(-)

-- 
1.7.5.4


