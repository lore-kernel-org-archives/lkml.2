Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0EUAVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 20:21:31 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39914 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab0EUAV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 20:21:29 -0400
Message-ID: <4BF5D203.7000007@linux.vnet.ibm.com>
Date: Thu, 20 May 2010 17:21:23 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 11/11] perf top: demo of how to use the sysfs
 interface
References: <1274233792.3036.90.camel@localhost> <4BF42B6F.6000009@linux.vnet.ibm.com> <1274318249.3603.135.camel@minggr.sh.intel.com> <4BF4915B.10104@linux.vnet.ibm.com> <1274386126.1674.1637.camel@laptop>
In-Reply-To: <1274386126.1674.1637.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/20/2010 1:08 PM, Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 18:33 -0700, Corey Ashford wrote:
>>
>> We also need to take into account event "attributes" - other data that
>> is needed to configure a specific event.  For example, think about a
>> memory controller which has a PMU can count events in a particular
>> memory range; we need to be able to supply the memory range somehow, 
> 
> That's that perf_event_attr is for.
> 

I think the issue is that what is stuffed into perf_event_attr's fields should be done in a way that userspace tools can figure out via attribute info which is in exported by the kernel via sysfs (or eventfs, etc.)

- Corey

