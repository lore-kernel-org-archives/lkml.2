Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0IJOzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:55:00 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:56702 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab0IJOy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:54:59 -0400
Date: Fri, 10 Sep 2010 23:54:51 +0900
From: Norbert Preining <preining@logic.at>
To: "Shi, Alex" <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: high power consumption in recent kernels
Message-ID: <20100910145451.GB21450@gamma.logic.tuwien.ac.at>
References: <1283840425.26157.6486.camel@debian> <20100909093140.GC29648@gamma.logic.tuwien.ac.at> <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com> <20100909205115.GD11053@gamma.logic.tuwien.ac.at> <1284107099.402.30.camel@laptop> <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 10 Sep 2010, Shi, Alex wrote:
> In the powertop source code, the "extra timer interrupt" come from /proc/timer_stats. If my understanding is correct, so many "extra timer interrupt" and the nohz_ratemlimit checking make your system can not go to deep C states. but don't know what the effect for "load balancing tick" come from "extra timer interrupt". So maybe reduce the "extra timer interrupt" is  helpful on your system. Could you like to try this? 

Can you be more specific how to do that?

- revert the nohz patch (can you send me a patch for that)
- how to reduce the "extra timer interrupt"?

Thanks

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
CAIRNPAT (n.)
A large piece of dried dung found in mountainous terrain above the
cowline which leads the experienced tracker to believe that hikers
have recently passed.
			--- Douglas Adams, The Meaning of Liff
