Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab1BWESD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:18:03 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61505 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1BWESB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:18:01 -0500
Message-ID: <4D648A65.2040107@dcl.info.waseda.ac.jp>
Date: Wed, 23 Feb 2011 13:17:41 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b10pre) Gecko/20110114 Thunderbird/3.3a2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf lock: clean the options for perf record
References: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <4D63D685.2010401@dcl.info.waseda.ac.jp> <1298389415.2217.243.camel@twins> <20110222182206.GB1799@nowhere>
In-Reply-To: <20110222182206.GB1799@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年02月23日 03:22, Frederic Weisbecker wrote:
> On Tue, Feb 22, 2011 at 04:43:35PM +0100, Peter Zijlstra wrote:
>> On Wed, 2011-02-23 at 00:30 +0900, Hitoshi Mitake wrote:
>>> How do you think about it?
>>
>> Most of the lock code (esp the spinlock stuff) is already way over the
>> threshold of sanity, adding to that for some dubious reasons doesn't
>> seem like a good idea.
>>
>> I'm still not at all sure why people want all this lock tracing.
>
> Right, well I can imagine many usecases that could make lock
> tracing bring more value than what lockstat already provides,
> through a tool like perf lock if we enhance it.
>
> We should probably first focus on developing the tooling side
> and make it useful enough that optimizations in the kernel
> side become desirable.
>

Yes, lockstat only provides the lock usage statistics of
entire of the system. perf lock will be able to provide the partial
information of specified term, or the degree of dependency
between locks.
