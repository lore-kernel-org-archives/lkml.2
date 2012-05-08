Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2EHQlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:41:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57951 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab2EHQlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:41:09 -0400
Message-ID: <4FA94C71.7000402@zytor.com>
Date: Tue, 08 May 2012 09:40:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
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
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com> <1336485790-30902-5-git-send-email-alex.shi@intel.com> <4FA938AE.9070209@zytor.com> <4FA94239.2010503@linux.intel.com>
In-Reply-To: <4FA94239.2010503@linux.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 08:56 AM, Andi Kleen wrote:
> 
>> This seems a bit concerning from a forward compatibility point of view.
>>   It would make more sense to assume that future processors would behave
>> more like the most recent (Sandy Bridge in your case) unless there is
>> evidence to the contrary.
> This would not work on new Atoms, which inter mix model numbers.
> 

That is another problem, but there isn't much we (as the Linux
community) can do about that, so we can just do the optimistic thing...

> In the past I did a hack in other software to check the cache sizes to
> distinguish the two
> for unknown models It's not pretty however.

Ick.

	-hpa

