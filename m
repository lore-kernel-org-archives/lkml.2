Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab0FENPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 09:15:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55529 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab0FENPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 09:15:13 -0400
Message-ID: <4C0A4DE9.4050306@vflare.org>
Date: Sat, 05 Jun 2010 18:45:21 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Greg KH <greg@kroah.com>,
       Ed Tomlinson <edt@aei.ca>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Cyp <cyp561@gmail.com>, driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Support generic I/O requests
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>	<1275379286-10453-2-git-send-email-ngupta@vflare.org>	<AANLkTimjc8eZY2IqbeZUR7VsWVspZ4ilUz3LPAUIiZuU@mail.gmail.com>	<20100604121957.d9bc55ae.akpm@linux-foundation.org> <AANLkTikzGnaJzZLq9Kd9JnMzGlg35-21T8A-zGmH1Ugn@mail.gmail.com>
In-Reply-To: <AANLkTikzGnaJzZLq9Kd9JnMzGlg35-21T8A-zGmH1Ugn@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On 06/05/2010 02:05 PM, Pekka Enberg wrote:
> 
> On Fri, Jun 4, 2010 at 10:19 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>> I thought zram is related to memory management a little bit.
>>>
>>> What's the criteria?
>>
>> Yes, and this is something which bothers me a bit about the -staging
>> process.  Code gets in there largely under the radar of the people who
>> work in that area.  It gets "matured" for a while and the developer
>> thinks it's all ready to go into "mainline" and ....  then what?
>> Someone needs to yank the code out of -staging and tell the interested
>> parties "hey, look at this".  And at this stage, they might say "hell
>> no", or request large changes and the developer who thought everything
>> was all ready to go would be justifiably upset.
>>
>> Obviously, this hasn't happened (much) with zram (partly because I
>> happened to notice it), but the potential is there.
>>
>> I'm not sure what a good solution is, really.  Obviously it would be
>> better if such code went straight into the subsystem maintainer's tree
>> on day one and got worked on there.  But if that process was working
>> efficiently, we wouldn't have ever needed ./staging/.
> 
> I thought the idea here is that when zram is "good enough", Nitin or
> Greg would post squashed patches of it for review and if maintainers
> are ready to take it, we'd merge the full history from -staging.
> 
> Not sure what Nitin's or Greg's plans are but I think it might be
> realistic to try to get zram properly merged for 2.6.36.
> 

Yes, I'm planning to move it to drivers proper in 2.6.36.

>> So I suppose we (ie: Greg ;)) should identify the destination
>> maintainer at the outset and make sure that the maintainer(s) and the
>> subsystem mailing list are kept in the loop on all developments, and
>> that they're aware that this code is headed their way.  Perhaps that's
>> already happening and I missed it.
> 
> Ramzswap and zram have been discussed on LKML. I guess Nitin should
> have CC'd linux-mm as well for you to see it? There hasn't been huge
> interest in reviewing the code which is why I suggested -staging in
> the first place. It ought to be a place where we can do in-tree
> development while we wait for the busy maintainers to have the chance
> to look at the code, no?
> 

Its all somewhat related to "compressed caching", so maybe linux-mm
should be added. I will do so for future patches which makes non-trivial
changes.

Thanks for your reviews and ACKs.

Nitin
