Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab2BCVv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:51:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:24335 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757959Ab2BCVv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:51:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="106092955"
Message-ID: <4F2C56D9.8010801@linux.intel.com>
Date: Fri, 03 Feb 2012 13:51:21 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jesper Juhl <jj@chaosbits.net>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][Trivial] Fix up version number reference in include/trace/events/power.h
References: <alpine.LNX.2.00.1201152146570.13389@swampdragon.chaosbits.net> <1326661784.7642.140.camel@gandalf.stny.rr.com> <alpine.LNX.2.00.1201152210300.13389@swampdragon.chaosbits.net> <alpine.LNX.2.00.1202032241380.25026@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1202032241380.25026@pobox.suse.cz>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/2012 1:42 PM, Jiri Kosina wrote:
> On Sun, 15 Jan 2012, Jesper Juhl wrote:
> 
>>>> -/* This code will be removed after deprecation time exceeded (2.6.41) */
>>>> +/* This code will be removed after deprecation time exceeded (3.1) */
>>>
>>> Shouldn't the real fix be to remove this code? What's the use of
>>> changing the version number that this code will be removed from, when
>>> the change won't get in until after the version that this code should
>>> have been removed?
>>>
>>> This is like updating 2014 calendars to say the world will end in 2012.
>>>
>> Heh, yeah, in a way you are right. But we have lots of code in the kernel 
>> that says it will be removed at <some date in the past>, so I just figured 
>> that if this code ends up hanging around it should at least display the 
>> correct version number for when it /should/ have been removed.
>> The actual removal I'll leave up to others.
> 
> Funny thing. Okay, this doesn't seem to be in linux-next, so I am taking 
> it.
> 
> Steven, planning to drop the code in a near future? :)

we shouldn't be dropping these yet.. tools are still using them.
and there really is no cost to keeping them either.
