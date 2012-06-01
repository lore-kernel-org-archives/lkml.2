Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab2FAJkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:40:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:29416 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759315Ab2FAJko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:40:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150330275"
Message-ID: <4FC88E18.2040107@linux.intel.com>
Date: Fri, 01 Jun 2012 17:40:40 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
References: <20120531145416.GI14515@aftab.osrc.amd.com> <4FC787BF.3020006@redhat.com> <20120531151408.GJ14515@aftab.osrc.amd.com> <4FC798E2.4000402@redhat.com> <20120531171337.GN14515@aftab.osrc.amd.com> <1338492772.13348.388.camel@gandalf.stny.rr.com> <20120531194207.GC16998@aftab.osrc.amd.com> <1338495092.13348.419.camel@gandalf.stny.rr.com> <20120531201824.GD16998@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F192F6DE2@ORSMSX104.amr.corp.intel.com> <20120601091026.GC20959@aftab.osrc.amd.com>
In-Reply-To: <20120601091026.GC20959@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/1 17:10, Borislav Petkov 写道:
> On Thu, May 31, 2012 at 08:52:21PM +0000, Luck, Tony wrote:
>>> It could be very quiet (i.e., machine runs with no errors) and
>>> it could have bursts where it reports a large number of errors
>>> back-to-back depending on access patterns, DIMM health,
>>> temperature, sea level and at least a bunch more factors.
>> 
>> Yes - the normal case is a few errors from stray neutrons ...
>> perhaps a few per month, maybe on a very big system a few per
>> hour.  When something breaks, especially if it affects a wide
>> range of memory addresses, then you will see a storm of errors.
> 
> IOW, when the sh*t hits the fan :-)
> 
>>> So I can imagine buffers filling up suddenly and fast, and
>>> userspace having hard time consuming them in a timely manner.
>> 
>> But I'm wondering what agent is going to be reporting all these 
>> errors.  Intel has CMCI - so you can get a storm of interrupts 
>> which would each generate a trace record ... but we are working 
>> on a patch to turn off CMCI if a storm is detected.
> 
> Yeah, about that. What are you guys doing about losing CECCs when 
> throttling is on, I'm assuming there's no way around it?
> 

This week I'm busy in doing other work so I have no time to do further
debug on Thomas' patch. I will continue to work on in the next days...
