Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2IZKrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:47:14 -0400
Received: from [216.32.180.14] ([216.32.180.14]:44350 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754445Ab2IZKqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:31 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275dhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDUT-02-545-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 00/19 v3] Improve IRQ remapping abstraction in x86 core code
Date: Wed, 26 Sep 2012 12:44:32 +0200
Message-ID: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the third version of the patch-set to improve the abstraction
of interrupt remapping in the x86 core code. A more detailed description
can be found in the original post at:

        https://lkml.org/lkml/2012/8/7/317

Changes from v2->v3:

	* Rebased to v3.6-rc7
	* Worked in most comments on v2 by Sebastian Andrzej Siewior

Changes from v1->v2:

        * Fixed a couple of compile issues on i386 (reported by
          Fengguang Wu, thanks a lot)
        * Rebased to Linux v3.6-rc2

Please review.

Cheers,

	Joerg


