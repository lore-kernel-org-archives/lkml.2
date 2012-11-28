Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab2K1OVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:21:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:38007 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab2K1OVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:21:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,177,1355126400"; 
   d="scan'208";a="255922140"
Message-ID: <50B61DD6.5020005@intel.com>
Date: Wed, 28 Nov 2012 22:21:10 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Shi <lkml.alex@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: numa/core regressions fixed - more testers wanted
References: <20121119162909.GL8218@suse.de> <20121119191339.GA11701@gmail.com> <20121119211804.GM8218@suse.de> <20121119223604.GA13470@gmail.com> <CA+55aFzQYH4qW_Cw3aHPT0bxsiC_Q_ggy4YtfvapiMG7bR=FsA@mail.gmail.com> <20121120071704.GA14199@gmail.com> <20121120152933.GA17996@gmail.com> <20121120175647.GA23532@gmail.com> <CAGjg+kHKaQLcrnEftB+2mjeCjGUBiisSOpNCe+_9-4LDho9LpA@mail.gmail.com> <20121122012122.GA7938@gmail.com> <20121123133138.GA28058@gmail.com> <CAGjg+kE8=cp=NyHrviyRWAZ=id6sZM1Gtb0N1_+SZ2TuBHE5cw@mail.gmail.com>
In-Reply-To: <CAGjg+kE8=cp=NyHrviyRWAZ=id6sZM1Gtb0N1_+SZ2TuBHE5cw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
>>
>> Could you please check tip:master with -v17:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master
>>

Tested this version on our SNB EP 2 sockets box, 8 cores * HT with
specjbb2005 on jrockit.
With single JVM setting it has 40% performance increase compare to
3.7-rc6. impressive!



