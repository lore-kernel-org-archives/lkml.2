Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2KTNNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:13:11 -0500
Received: from 8bytes.org ([85.214.48.195]:58210 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab2KTNNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:13:06 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 00/19 v4] Improve IRQ remapping abstraction in x86 core code
Date: Tue, 20 Nov 2012 14:12:37 +0100
Message-Id: <1353417176-18945-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Nov 20 14:13:04 2012
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ab81e022971291120965
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the fourth version of the patch-set to improve the abstraction
of interrupt remapping in the x86 core code. A more detailed description
can be found in the original post at:

        https://lkml.org/lkml/2012/8/7/317

Changes from v3->v4:

	* Rebased to v3.7-rc6
	* Added Acked-bys
	* Fixed problems with AMD IRQ remapping code that came up
	  in testing

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


