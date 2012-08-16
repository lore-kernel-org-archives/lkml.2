Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2HPF0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 01:26:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:34235 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab2HPF03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 01:26:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,776,1336374000"; 
   d="scan'208";a="187047574"
Message-ID: <502C8479.1090704@intel.com>
Date: Thu, 16 Aug 2012 13:26:17 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Rakib Mullick <rakib.mullick@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com>  <CADZ9YHhB_1ZeZM3WOFiz0kcx1ZR9iFO_R=Mst_w=QKXOi4Z9OQ@mail.gmail.com> <1345042516.31459.99.camel@twins>
In-Reply-To: <1345042516.31459.99.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 10:55 PM, Peter Zijlstra wrote:

> On Wed, 2012-08-15 at 20:24 +0600, Rakib Mullick wrote:
>> How do you plan to test this power saving scheme? Using powertop? Or,
>> is there any other tools? 
> 
> We should start out simple enough that we can validate it by looking at
> task placement by hand, eg. 4 tasks on a dual socket quad-core, should
> only keep one socket awake.
> 
> We can also add an power aware evaluator to Linsched (another one of
> those things that needs getting sorted).
> 
> And yeah, someone running with a power meter is of course king.
> 
> _BUT_ we shouldn't go off the wall with power meters as that very
> quickly gets very specific to the system being measured.
> 
> We should really keep this thing as simple as possible while still
> providing some benefit for all various architectures without tons of per
> arch knobs and knowhow.


Definitely agree all!
