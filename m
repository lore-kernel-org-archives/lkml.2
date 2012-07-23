Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2GWRuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:50:12 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:2045
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754158Ab2GWRuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:50:10 -0400
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT003.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzzz2fh2a8h668h839hd24he5bhf0ah107ah)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 0/5] staging: ozwpan: Various Bug fixes 
Date: Mon, 23 Jul 2012 18:49:42 +0100
Message-ID: <1343065787-7616-1-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes various bugs found during development & bumps 
version number to keep it in sync with internal version number.

Rupesh Gujare (5):
  staging: ozwpan: buffer frame if urb not available.
  staging: ozwpan: Insulate driver from HZ value
  staging: ozwpan: Return correct actual_length to userland
  staging: ozwpan: isoc latency for audio burst
  staging: ozwpan: Bump version number

 drivers/staging/ozwpan/ozhcd.c      |   89 +++++++++++++++++++++++++++++------
 drivers/staging/ozwpan/ozmain.c     |    2 +-
 drivers/staging/ozwpan/ozpd.c       |    8 +---
 drivers/staging/ozwpan/ozpd.h       |    1 +
 drivers/staging/ozwpan/ozproto.c    |   13 +++++
 drivers/staging/ozwpan/ozproto.h    |    8 +++-
 drivers/staging/ozwpan/ozprotocol.h |    6 ++-
 7 files changed, 103 insertions(+), 24 deletions(-)

-- 
1.7.5.4


