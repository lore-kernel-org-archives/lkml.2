Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab0LVGr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 01:47:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:21468 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab0LVGr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 01:47:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,211,1291622400"; 
   d="scan'208";a="639162381"
Message-ID: <4D119F02.3060900@linux.intel.com>
Date: Tue, 21 Dec 2010 22:47:30 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/4] futex,plist: remove debug lock assignment for plist_node
References: <4D10797E.7040803@cn.fujitsu.com> <4D10FC90.6020104@linux.intel.com> <4D119353.9030401@cn.fujitsu.com>
In-Reply-To: <4D119353.9030401@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 09:57 PM, Lai Jiangshan wrote:
> On 12/22/2010 03:14 AM, Darren Hart wrote:
>> On 12/21/2010 01:55 AM, Lai Jiangshan wrote:
>>> original code use&plist_node->plist as the faked head of
>>> the priority list for plist_del(), these debug locks in
>>> the faked head are needed for CONFIG_DEBUG_PI_LIST.
>>>
>>> But now we always pass the real head to plist_del(), the debug locks
>>> in plist_node will not be used, so we remove these assignments.
>>
>> Any reason to keep this separate from  patch 1/4 ?
>>
>
> Make the changes clearer and the patches are easier to read.
> For me the purposes of patch 1/4 and 2/4 are different,
> 1/4 makes the code sensible. 2/4 removes unused code.

Fair enough.

-- 
Darren Hart
Yocto Linux Kernel
