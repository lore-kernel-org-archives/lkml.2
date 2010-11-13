Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0KMTlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 14:41:15 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50458 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab0KMTlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 14:41:13 -0500
Subject: Re: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4CDEE314.6090107@kernel.org>
References: <20101111100628.GA24728@localhost>
	 <1289478978.2084.74.camel@laptop> <20101111124015.GA9706@localhost>
	 <1289480656.2084.80.camel@laptop> <20101113084018.GA23098@localhost>
	 <1289644224.2084.521.camel@laptop> <20101113120030.GA31517@localhost>
	 <1289653078.2084.675.camel@laptop> <20101113131042.GA5522@localhost>
	 <4CDEE314.6090107@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 20:41:17 +0100
Message-ID: <1289677277.2109.173.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 11:12 -0800, Yinghai Lu wrote:
> > [    0.633006] Total of 8 processors activated (44799.46 BogoMIPS).
> 
> assume that when you have 
> CONFIG_NR_CPUS=16
> instead of
> CONFIG_NR_CPUS=8
> 
> it will boot ok? 

If it would that'd still be a bug.
