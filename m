Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab2F0JRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:17:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43923 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2F0JRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:17:05 -0400
Message-ID: <1340788213.10063.0.camel@twins>
Subject: Re: [PATCH V5 0/13] perf: Intel uncore pmu counting support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 11:10:13 +0200
In-Reply-To: <CABPqkBSPFCmmd55EanLrb7e84UTHT4MqrZh-H-q7RE+Pg6Akcg@mail.gmail.com>
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
	 <CABPqkBQu1hTa2R-PKsygLqOSSD9nu3+xR-79pT-8bB8Y16CBuw@mail.gmail.com>
	 <4FD7EFCB.6060005@intel.com> <1339578142.31548.128.camel@twins>
	 <4FD949FF.7060207@intel.com>
	 <CABPqkBTPah786S+GR=TdGCTxGzBEVg-Q2r0YAUFrYAm5iVEf=w@mail.gmail.com>
	 <CABPqkBSPFCmmd55EanLrb7e84UTHT4MqrZh-H-q7RE+Pg6Akcg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 03:05 +0200, Stephane Eranian wrote:
> If you compile the uncore support in 32-bit mode, you will
> get a warning on the hrtimer_start_range_ns() functions
> because the interval is passed as ktime_t whereas the
> function expects unsigned long.  With 64-bit, no problem
> ktime_t is a union with s64. But in 32-bit mode, there is
> a possible truncation of the delta. This needs to be
> fixed. 

Right, Andrew has a patch for that, I guess I'd better make sure it
appears in tip as well.


