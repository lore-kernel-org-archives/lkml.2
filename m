Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0L0Sod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 13:44:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56830 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab0L0Soc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 13:44:32 -0500
Message-ID: <4D18DE41.3060106@zytor.com>
Date: Mon, 27 Dec 2010 10:43:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Venkatesh Pallipadi <venki@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH -v2 2/2] x86, acpi: Parse all SRAT cpu entries even have
 cpu num limitation
References: <20101111100628.GA24728@localhost> <1289478978.2084.74.camel@laptop> <20101111124015.GA9706@localhost> <1289480656.2084.80.camel@laptop> <20101113084018.GA23098@localhost> <1289644224.2084.521.camel@laptop> <20101113120030.GA31517@localhost> <1289653078.2084.675.camel@laptop> <20101113131042.GA5522@localhost> <4CDEE314.6090107@kernel.org> <20101113235746.GA9458@localhost> <4CDF3DA1.2090806@kernel.org> <4D093ABB.4030206@zytor.com> <4D0943D5.1090404@kernel.org> <4D094703.7080701@zytor.com> <4D0AD464.2020408@kernel.org> <4D0AD486.9020704@kernel.org> <AANLkTin-LGig2RHHmvvy5H04jQRus_1mmS1Cr4KDWKsN@mail.gmail.com> <4D0BB9AD.90506@kernel.org> <AANLkTimw_nvDEb4t1nOQFCtY8fx6fvg5Mmy+6vZw8mw1@mail.gmail.com> <AANLkTi=VYooLbwWkTCSfQ38z=UO_kQZyQyKaw-5+kyYn@mail.gmail.com> <alpine.DEB.2.00.1012212230580.9505@chino.kir.corp.google.com> <AANLkTim7GbOJzjt9Wdba-pdAj+GUR1xZCqOv+bDmypTj@mail.gmail.com> <alpine.DEB.2.00.1012221446460.2612@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1012221446460.2612@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2010 02:51 PM, David Rientjes wrote:
> The specific fix should be d845c04a from that tree (x86, numa: Fake 
> node-to-cpumask for NUMA emulation).
> 
> Peter, I'm assuming these fixes are on track for .38 (although they have 
> been pending for a couple months and I was hoping for .37 inclusion)?

Yes, .38.

	-hpa
