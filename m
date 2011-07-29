Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1G2AOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 20:14:04 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:34793 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755550Ab1G2AOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 20:14:02 -0400
Message-ID: <4E31FB43.9050203@localhost>
Date: Thu, 28 Jul 2011 17:13:55 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [ANNOUNCE] 3.0-rt4
References: <alpine.LFD.2.02.1107272222420.2660@ionos> <4E31B59F.1000607@localhost> <alpine.LFD.2.02.1107282123380.2660@ionos>
In-Reply-To: <alpine.LFD.2.02.1107282123380.2660@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2011 12:36 PM, Thomas Gleixner wrote:
> On Thu, 28 Jul 2011, Fernando Lopez-Lezcano wrote:
>
>> On 07/27/2011 02:37 PM, Thomas Gleixner wrote:
>>> Dear RT Folks,
>>>
>>> I'm pleased to announce the 3.0-rt4 release.
>>
>> Testing rt5 (lenovo dual core laptop running fc15, kernel based on koji's
>> 3.0.0 build plus rt5)...
...
>> (I guess because HIGHMEM is disabled the computer only finds 800M+ of LOWMEM
>> and that is all top reports - total installed is 4G)
>
> Yes, that's the state for now until someone fixes it :)

Oh well... :-<
-- Fernando
