Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab0JDJHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:07:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56925 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0JDJHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:07:37 -0400
Date: Mon, 4 Oct 2010 11:07:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Huang Ying <ying.huang@intel.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20101004090728.GC20013@basil.fritz.box>
References: <20100929170924.GR13563@erda.amd.com>
 <20100929181207.GW26290@redhat.com>
 <AANLkTimp=+1GzBOYaUZWtDF6teGt6FZe+RTpb9fAyOyd@mail.gmail.com>
 <20100930091246.GV13563@erda.amd.com>
 <20100930194451.GI26290@redhat.com>
 <20101001071750.GB13563@erda.amd.com>
 <AANLkTimUyLaVaBigjm0-CwRsdh4UXWDiss2ffX53S+k_@mail.gmail.com>
 <AANLkTik4KmzqeHTGXZAcQtg80YkBRPDqegLOaMvTvDAQ@mail.gmail.com>
 <20101002093524.GJ13563@erda.amd.com>
 <AANLkTi=YNhc0g+Cwcwg=DdoYJUxO7sb6GZSAEC-qvEU+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=YNhc0g+Cwcwg=DdoYJUxO7sb6GZSAEC-qvEU+@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I haven't seen Andi's suggestion. But I am guessing he is suggesting
> adding a new chain that would be called first and where there would
> ONLY be the perf_event subsystem. To handle the spurious PMU

I was thinking of a separate NMI chain 

(and longer term really splitting the die chains into separate chains,
that would solve other problems e.g. with page fault performance
too) 

Possibly that NMI chain could be split up too, but not sure
this is really needed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
