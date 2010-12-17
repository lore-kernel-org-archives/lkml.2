Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab0LQT3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:29:44 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:49483 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0LQT3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:29:40 -0500
Message-ID: <4D0BB9AD.90506@kernel.org>
Date: Fri, 17 Dec 2010 11:27:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH -v2 2/2] x86, acpi: Parse all SRAT cpu entries even have
 cpu num limitation
References: <20101111100628.GA24728@localhost>	<1289478978.2084.74.camel@laptop>	<20101111124015.GA9706@localhost>	<1289480656.2084.80.camel@laptop>	<20101113084018.GA23098@localhost>	<1289644224.2084.521.camel@laptop>	<20101113120030.GA31517@localhost>	<1289653078.2084.675.camel@laptop>	<20101113131042.GA5522@localhost>	<4CDEE314.6090107@kernel.org>	<20101113235746.GA9458@localhost>	<4CDF3DA1.2090806@kernel.org>	<4D093ABB.4030206@zytor.com>	<4D0943D5.1090404@kernel.org>	<4D094703.7080701@zytor.com>	<4D0AD464.2020408@kernel.org>	<4D0AD486.9020704@kernel.org> <AANLkTin-LGig2RHHmvvy5H04jQRus_1mmS1Cr4KDWKsN@mail.gmail.com>
In-Reply-To: <AANLkTin-LGig2RHHmvvy5H04jQRus_1mmS1Cr4KDWKsN@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 10:53 AM, Venkatesh Pallipadi wrote:
> linus git + these two patches still fails on my test system with the
> divide error. The failure dump is similar to what I reported here
> http://lkml.indiana.edu/hypermail//linux/kernel/1012.1/03641.html
> 
> This patch description talk about new Intel systems. The test system I
> am seeing failure here is an ancient Intel (2 socket P4 HT) system.
> AFAICS, it does not even have an SRAT table (no "ACPI: SRAT" message
> in dmesg).

that could be different cause.

Do you have whole boot log with debug etc?

