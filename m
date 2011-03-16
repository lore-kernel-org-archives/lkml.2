Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1CPSGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:06:41 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:59370 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1CPSGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:06:36 -0400
X-SpamScore: 0
X-BigFish: VPS0(zz4015L2f55kzz1202hzzz32i668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI5WX6-01-8IJ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Subject: [PATCH 0/2] oprofile cleanups
Date: Wed, 16 Mar 2011 18:58:23 +0100
Message-ID: <1300298305-9164-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These 2 patches contain some cleanups I made while reviewing oprofile
s390 code. I already applied them to my oprofile git tree, but please
take a look at it anyway.

Ingo, since the patches are cleanups, I think it is ok to add them to
my oprofile pull request for .39 for you that I will send out soon.
All other patches are already in linux-next for several weeks. Is this
ok for you too?

Thanks,

-Robert



