Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab2EHP4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:56:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:28061 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab2EHP4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:56:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="141459874"
Message-ID: <4FA94239.2010503@linux.intel.com>
Date: Tue, 08 May 2012 08:56:41 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alex Shi <alex.shi@intel.com>, mgorman@suse.de, npiggin@gmail.com,
        tglx@linutronix.de, mingo@redhat.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        gregkh@linuxfoundation.org, glommer@redhat.com, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] x86/tlb: add tlb flush all factor for specific
 CPUs
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com> <1336485790-30902-5-git-send-email-alex.shi@intel.com> <4FA938AE.9070209@zytor.com>
In-Reply-To: <4FA938AE.9070209@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This seems a bit concerning from a forward compatibility point of view.
>   It would make more sense to assume that future processors would behave
> more like the most recent (Sandy Bridge in your case) unless there is
> evidence to the contrary.
This would not work on new Atoms, which inter mix model numbers.

In the past I did a hack in other software to check the cache sizes to 
distinguish the two
for unknown models It's not pretty however.

-Andi


