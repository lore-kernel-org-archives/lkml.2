Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1EaR30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:29:26 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:10543 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932109Ab1EaR3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:29:23 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LM2LWT-01-4H5-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 0/3] oprofile fixes for 3.0
Date: Tue, 31 May 2011 18:46:43 +0200
Message-ID: <1306860406-6094-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.5.rc3
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fixes for 3.0 for review. Will apply them later and send a pull
request.

Thanks

-Robert


The following changes since commit cbf74cea070fa1f705de4712e25d9e56ae6543c7:

  oprofile, x86: Add comments to IBS LVT offset initialization (2011-05-30 16:36:54 +0200)

Robert Richter (3):
      oprofile: Free potentially owned tasks in case of errors
      oprofile: Fix locking dependency in sync_start()
      oprofile, dcookies: Fix possible circular locking dependency

 drivers/oprofile/buffer_sync.c |   21 +++++++++++----------
 fs/dcookies.c                  |    3 +++
 2 files changed, 14 insertions(+), 10 deletions(-)



