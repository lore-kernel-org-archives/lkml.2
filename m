Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab2EDGva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 02:51:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:2723 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab2EDGva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 02:51:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96284471"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, bp@amd64.org, npiggin@gmail.com
Cc: jeremy@goop.org, riel@redhat.com, luto@mit.edu, alex.shi@intel.com,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, yinghai@kernel.org, borislav.petkov@amd.com,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, yongjie.ren@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] tlb_flush_range optimization 
Date: Fri,  4 May 2012 14:50:05 +0800
Message-Id: <1336114210-25687-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove glommer@redhat.com and add lkml.

This is the second version of patchset, 3 main changes:
1, move tlb info getting function to cpu vendor specific files, that is friendly
for other x86 cpu vendor developers to adding their code
2, add a interface to give the different optimization factor for different cpu type
3, tested 3 intel's cpu families: NHM, SNB, core2 and set the specific optimizing
factors for them.

Riel: would you like to update you ack to this version?

Boris: you can enable AMD cpu base on this version. 

Happy coding!
and 
Comments appreciated!

Alex Shi

