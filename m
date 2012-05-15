Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab2EOI5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:57:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:36405 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758465Ab2EOI5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:57:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166449501"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, riel@redhat.com, luto@mit.edu, alex.shi@intel.com,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: [PATCH v5 0/7] tlb flush optimization for x86
Date: Tue, 15 May 2012 16:55:31 +0800
Message-Id: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the 5th version patchset. New changes are:
1, tlb_flushall_shift knob move to debugfs.
2, include model 58 IVB mobile CPU tlb_flushall_shift setting
3, many small code changes response for most all of comments for v4.

Any more comments are appreciated!

Alex Shi

