Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861Ab2GFKqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:46:07 -0400
Received: from mx2.parallels.com ([64.131.90.16]:59541 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933034Ab2GFKqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:46:04 -0400
Message-ID: <4FF6C148.7030402@parallels.com>
Date: Fri, 6 Jul 2012 14:43:20 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Richard Cochran <richardcochran@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jonathan Corbet <corbet@lwn.net>,
        <ksummit-2012-discuss@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the question!
References: <alpine.LFD.2.02.1206152313310.3086@ionos> <20120615233413.GB8894@kroah.com> <alpine.LFD.2.02.1206161103320.3086@ionos> <20120616072906.7469ec24@tpl.lwn.net> <20120620195121.GA1719@fieldses.org> <4FF6B32A.7070006@parallels.com> <20120706095450.GB7728@somewhere.redhat.com> <20120706101149.GA26028@localhost.localdomain> <4FF6BFC7.9060405@linux.vnet.ibm.com>
In-Reply-To: <4FF6BFC7.9060405@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 02:36 PM, Srivatsa S. Bhat wrote:
> On 07/06/2012 03:41 PM, Richard Cochran wrote:
>> On Fri, Jul 06, 2012 at 11:54:52AM +0200, Frederic Weisbecker wrote:
>>> On Fri, Jul 06, 2012 at 01:43:06PM +0400, Glauber Costa wrote:
>>>> The same way we have checkpatch, we can have something automated that
>>>> will attempt to rule out some trivial patches in the counting process.
>>>> We can scan a patch, and easily determine if each part of it is:
>>>>
>>>> * pure whitespace
>>>> * pure Documentation change
>>>> * comment fix
>>>>
>>>> And if a patch is 100 % comprised by those, we simply don't count it.
>>>> People that just want to increase their numbers - they will always
>>>> exist, will tend to stop doing that. Simply because doing it will not
>>>> help them at all.
>>>
>>> OTOH, documentation changes or comment fixes, and even sometimes pure whitespace
>>> fixes, can be very valuable contributions. This can be a useful and ungrateful
>>> work and that deserve credit.
>>>
>>> We just can't find an automated and right way to evaluate a contribution.
>>
>> Well what about submitters and maintainers labeling patches below the
>> SOB with tags like the following?
>>
>>    Signed-off-by: Richard Cochran <richardcochran@gmail.com>
>>    Tags: docu whitespace trivial
>>
>> Part of the review would be making sure the labels fit.
>>
> 
> Please no!
> I don't see why we should clutter the changelog with tags for reasons as
> unimportant as measuring some patch's value!
> 
Stronger: Having the maintainer to do more work is hardly a way to decrease
the amount of work he does. (Well, it could be in some cases, but not in
this)



