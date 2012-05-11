Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2EKIBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:01:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:6295 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab2EKIBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:01:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="139414073"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, tj@kernel.org,
        cl@linux-foundation.org, tony.luck@intel.com, bp@amd64.org,
        davem@davemloft.net
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, sfr@canb.auug.org.au,
        alex.shi@intel.com, luto@mit.edu, glommer@parallels.com,
        fernando@oss.ntt.co.jp, vapier@gentoo.org, eric.dumazet@gmail.com,
        dzickus@redhat.com, dhowells@redhat.com, cbouatmailru@gmail.com,
        fenghua.yu@intel.com, jkosina@suse.cz, ext-phil.2.carmody@nokia.com,
        dan.carpenter@oracle.com, len.brown@intel.com, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org, anton@samba.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] replace percpu_ops function with this_cpu_ops 
Date: Fri, 11 May 2012 16:00:12 +0800
Message-Id: <1336723215-16660-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am sorry for mess commit log previous patchset.

As Andrew Morton's request, I combind and clean up the patchset.

According to Ingo's complain. I use the same and short 
'this_cpu_ops' functions in x86 part code.

Thanks for all comments!

[PATCH 1/3] net: replace percpu_xxx funcs with this_cpu_xxx or
[PATCH 2/3] x86: replace percpu_xxx funcs with this_cpu_xxx
[PATCH 3/3] percpu: remove percpu_xxx() functions
