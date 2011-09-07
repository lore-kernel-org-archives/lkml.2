Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1IGQdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:33:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:38263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1IGQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:33:08 -0400
Message-ID: <4E677AF5.7050903@infradead.org>
Date: Wed, 07 Sep 2011 11:08:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Josh Boyer <jwboyer@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: no tree for Sept 6
References: <20110906164049.4dd3961cb82800b8d7cc8741@canb.auug.org.au> <CACqU3MXcZ72eYNd=duPYdR_gOe-ejnHoLSMqK_ZU3y=MR2-0+A@mail.gmail.com> <CA+5PVA7CETUa0i3U20ifz5YjXAywTGD2NEQt1GcJz1OwY_DtEg@mail.gmail.com> <CACqU3MXQw4+QyBmCPcO8ZmYu0T6N+DStXBoa=JUv+ej6cWMTnw@mail.gmail.com> <CA+5PVA7Oj9BNTA93m8-rj4a7Ze_N7m3mG0-+GLG1zUSG+ekqJQ@mail.gmail.com> <CACqU3MW3w10LsZvyY4RNQ1-0TgrW39PaGeVnj78bk+p6c=1uFQ@mail.gmail.com>
In-Reply-To: <CACqU3MW3w10LsZvyY4RNQ1-0TgrW39PaGeVnj78bk+p6c=1uFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 06-09-2011 15:30, Arnaud Lacombe escreveu:
> Hi,
> 
> On Tue, Sep 6, 2011 at 2:18 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>> On Tue, Sep 6, 2011 at 1:29 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>> Hi,
>>>
>>> On Tue, Sep 6, 2011 at 1:23 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>>> On Tue, Sep 6, 2011 at 1:17 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>>>> Hi,
>>>>>
>>>>> On Tue, Sep 6, 2011 at 2:40 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> With master.kernel.org down, there is not much change from yesterday and
>>>>>> I cannot publish the resulting linux-next tree anyway, so there is no
>>>>>> tree today.
>>>>>>
>>>>> What about github ? gitorious ?
>>>>>
>>>>> If you fork linus' tree on github, you should still be within the disk
>>>>> usage limit. My linux-2.6-next.git bare tree mirror is about 303MB.
>>>>
>>>> Well... that would be helpful if all of the trees that linux-next
>>>> pulls from are hosted somewhere other than kernel.org as well.  A lot
>>>> of them are not, which means you would get an incomplete linux-next
>>>> tree at best.  Probably better to just wait.
>>>>
>>> That's just insane...
>>
>> It's insane for people to host their git trees for kernel work on kernel.org?
>>
> Yes. It is looking for trouble by creating a wonderful single point of
> failure. Which happened to have failed.

It seems that we need a backup plan. In my case, I could put the tree
for -next at infradead or at linuxtv, but that means to re-configure
everything at Stephen's side.

Does anyone have an ETA for hera to come back to live? If they're
planning to recover it into one or two days, then it is probably better
to wait. Otherwise, I think it would be wiser to move the repo to
some other place while they're preparing a new infrastructure.

> If I were to be really paranoid, I would no longer trust any code on
> git.kernel.org unless all the current repository were to be destroyed,
> and re-uploaded by their owner.

In any case, I'll just do a push -f after hera return, and do a 
git repack -A -d on my repository there, to remove any bad object
that might be inserted by someone's else.

> 
>  - Arnaud
> 
>>> git is distributed, but still used centrally. Kernel development
>>> should just not be impacted by such issues.
>>
>> No... git is still used in a distributed fashion.  It's just that most
>> maintainers host the public trees that people pull from on kernel.org.
>>  Some have pushed public trees to github or elsewhere, but not all of
>> them.
>>
>> josh
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

