Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967203Ab2EPBBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:01:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:50568 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965036Ab2EPBBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:01:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153420867"
Date: Wed, 16 May 2012 09:04:39 +0800
From: Xudong Hao <xudong.hao@linux.intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, haitao.shan@intel.com,
        xiantao.zhang@intel.com, xudong.hao@intel.com
Subject: [PATCH 0/4] KVM: Enable EPT access bit feature
Message-ID: <20120516010439.GA14256@hp-xd.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EPT A/D bits enable VMMs to efficiently implement memory management and page classification algorithms to optimize VM memory operations such as de-fragmentation, paging, live-migration, and check-pointing.

The series of patches enable the EPT access bit in KVM.

PATCH 1: Add EPT A/D bits definition.
PATCH 2: Add kernel parameter to control EPT A/D bits support, the feature is on by default.
PATCH 3: Enable EPT A/D bits if supported by turning on relevant bit in EPTP.
PATCH 4: Enabling Access bit when doing memory swapping.

