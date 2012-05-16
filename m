Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030359Ab2EPLvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:51:08 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967450Ab2EPLvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:51:06 -0400
Message-ID: <4FB394A6.5080402@nod.at>
Date: Wed, 16 May 2012 13:51:02 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        Heinz.Egger@linutronix.de, tglx@linutronix.de, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org
Subject: Re: Fastmap - please, review and test
References: <1337101871-31181-1-git-send-email-richard@nod.at>  <20120515224645.3af023c3@halley> <1337151273.24809.2.camel@sauron.fi.intel.com>
In-Reply-To: <1337151273.24809.2.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.05.2012 08:54, Artem Bityutskiy wrote:
> On Tue, 2012-05-15 at 22:46 +0300, Shmulik Ladkani wrote:
>> On Tue, 15 May 2012 19:11:04 +0200 Richard Weinberger<richard@nod.at>  wrote:
>>> TODO:
>>>          - Artem is fully happy with the current on-flash layout,
>>>            maybe I can merge the erase counters into the EBA table
>>>          - Get a full review :)
>>
>> I'd be glad to take a deep look of the code.
>>
>> Hopefully I'll get into it in the following days.
>
> Thanks Shmulik - I appreciate any help as much as Richard. I am busy and
> my job now has nothing to do with MTD/UBI/UBIFS, and I have limited time
> for review.
>
> There were many people who wanted faster UBI, and I'd ask them to
> participate now - review, test, etc.
>

Before you shoot me, an hour ago I found an issue with static volumes 
that are not LEB aligned.
Looks like I'm calculating the volume length wrong.
I'll send as soon as possible a fix!

Thanks,
//richard
