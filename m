Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab2DJRWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:22:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:7525 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab2DJRWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:22:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="127394352"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: x86@kernel.org
Cc: hpa@zytor.com, neilb@suse.de, linux-kernel@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de
Subject: arch/86: AVX RAID5 xor checksumming
Date: Tue, 10 Apr 2012 10:22:30 -0700
Message-Id: <1334078551-6859-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

The following patch adds an AVX implementation of the RAID5 xor checksumming
functions.

Based on xor_speed, the AVX implementation appears to be ~32% faster than the
SSE implementation on my i7 2600:

        generic_sse: 15088.000 MB/sec
	avx: 19936.000 MB/sec

Thanks.

