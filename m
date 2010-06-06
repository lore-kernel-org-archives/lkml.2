Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab0FFXcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 19:32:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33377 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab0FFXcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 19:32:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rInUtkjgbBEtAE3CU/8v/XA1YSc4yUnHanrLbUJTE7dLxdtWRSxdHPZd8pS6t9wtM7
         UQDU+qxkuXL4U3teKeJh9SpYmE2VHcTzGj9dJ+ZnlzWh3al8F9QnDgX53fJ/V5eHpqWe
         CVrVKauIw0Mg8TpPaU50AJPtskd6xqMfg69dY=
MIME-Version: 1.0
In-Reply-To: <AANLkTikzGnaJzZLq9Kd9JnMzGlg35-21T8A-zGmH1Ugn@mail.gmail.com>
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
	<1275379286-10453-2-git-send-email-ngupta@vflare.org>
	<AANLkTimjc8eZY2IqbeZUR7VsWVspZ4ilUz3LPAUIiZuU@mail.gmail.com>
	<20100604121957.d9bc55ae.akpm@linux-foundation.org>
	<AANLkTikzGnaJzZLq9Kd9JnMzGlg35-21T8A-zGmH1Ugn@mail.gmail.com>
Date: Mon, 7 Jun 2010 08:32:50 +0900
Message-ID: <AANLkTimAqHgKkNdvcLvw6fi301dD2PCO0zH2Ui_LpNgV@mail.gmail.com>
Subject: Re: [PATCH 1/4] Support generic I/O requests
From: Minchan Kim <minchan.kim@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
       Greg KH <greg@kroah.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pekka.

On Sat, Jun 5, 2010 at 5:35 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Andrew,
>
> On Fri, Jun 4, 2010 at 10:19 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>> I thought zram is related to memory management a little bit.
>>>
>>> What's the criteria?
>>
>> Yes, and this is something which bothers me a bit about the -staging
>> process.  Code gets in there largely under the radar of the people who
>> work in that area.  It gets "matured" for a while and the developer
>> thinks it's all ready to go into "mainline" and ....  then what?
>> Someone needs to yank the code out of -staging and tell the interested
>> parties "hey, look at this".  And at this stage, they might say "hell
>> no", or request large changes and the developer who thought everything
>> was all ready to go would be justifiably upset.
>>
>> Obviously, this hasn't happened (much) with zram (partly because I
>> happened to notice it), but the potential is there.
>>
>> I'm not sure what a good solution is, really.  Obviously it would be
>> better if such code went straight into the subsystem maintainer's tree
>> on day one and got worked on there.  But if that process was working
>> efficiently, we wouldn't have ever needed ./staging/.
>
> I thought the idea here is that when zram is "good enough", Nitin or
> Greg would post squashed patches of it for review and if maintainers
> are ready to take it, we'd merge the full history from -staging.
>
> Not sure what Nitin's or Greg's plans are but I think it might be
> realistic to try to get zram properly merged for 2.6.36.
>
>> So I suppose we (ie: Greg ;)) should identify the destination
>> maintainer at the outset and make sure that the maintainer(s) and the
>> subsystem mailing list are kept in the loop on all developments, and
>> that they're aware that this code is headed their way.  Perhaps that's
>> already happening and I missed it.
>
> Ramzswap and zram have been discussed on LKML. I guess Nitin should
> have CC'd linux-mm as well for you to see it? There hasn't been huge
> interest in reviewing the code which is why I suggested -staging in
> the first place. It ought to be a place where we can do in-tree
> development while we wait for the busy maintainers to have the chance
> to look at the code, no?

Fair enough.

AFAIR, mm forks haven't been interest in reviewing the code except
allocator at that time. but at least, Greg or someone should have Cced
one maintainer or mailing list related to patches to notice them.
"It's growing in here(ie, staging) and be ready to go to the
mainline". :)

-- 
Kind regards,
Minchan Kim
