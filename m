Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0JOOmC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:42:02 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19212 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab0JOOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:42:00 -0400
Message-ID: <4CB86804.7090600@oracle.com>
Date: Fri, 15 Oct 2010 07:41:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Ben Pfaff <blp@cs.stanford.edu>
CC: Bruno Randolf <br1@einfach.org>, linux-kernel@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add generic exponentially weighted moving average function
References: <20101006093225.8739.14012.stgit@tt-desk>	<20101012173352.0a458c24.randy.dunlap@oracle.com> <87y6a0unrr.fsf@benpfaff.org>
In-Reply-To: <87y6a0unrr.fsf@benpfaff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/10 20:40, Ben Pfaff wrote:
> Randy Dunlap <randy.dunlap@oracle.com> writes:
> 
>> On Wed, 06 Oct 2010 18:32:25 +0900 Bruno Randolf wrote:
>>
>>> This adds a generic exponentially weighted moving average function. This
>>> implementation makes use of a structure which keeps a scaled up internal
>>> representation to reduce rounding errors.
>>>
>>> The idea for this implementation comes from the rt2x00 driver (rt2x00link.c)
>>> and i would like to use it in several places in the mac80211 and ath5k code.
>>
>> I guess I don't understand "exponentially weighted" or why that would
>> be desirable.  Please try to explain (briefly).
> 
> I wrote up a fairly non-brief explanation of exponentially
> weighted moving averages a few years ago:
>         http://www.stanford.edu/class/cs140/projects/pintos/pintos_7.html#SEC134

Thanks, nice writeup.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
