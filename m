Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363Ab2EIXpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:45:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:45356 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527Ab2EIXpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:45:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151187434"
Date: Wed, 9 May 2012 16:45:12 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <alex.shi@intel.com>, mgorman@suse.de, npiggin@gmail.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        gregkh@linuxfoundation.org, glommer@redhat.com, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] TLB flush optimization
Message-ID: <20120509234512.GA27196@tassilo.jf.intel.com>
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
 <1336489319.16236.43.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336489319.16236.43.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Have you tried what happens if you get rid of the funny multi-vector-ipi
> scheme and use the generic smp_call functions?

Yes we did. It's much faster on larger systems.

But haven't sent the patch yet because wasn't sure if it wasn't slower
on small systems.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
