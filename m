Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1H2U6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 16:58:44 -0400
Received: from natasha.panasas.com ([67.152.220.90]:56702 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab1H2U6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 16:58:43 -0400
Message-ID: <4E5BFD36.2090000@panasas.com>
Date: Mon, 29 Aug 2011 13:57:26 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Git Mailing List <git@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Subject: Re: [PATCH] .gitattributes: Enable cpp diff parsing for .[ch] files
References: <4E56CE8F.8080501@panasas.com>  <CA+55aFxNXK-AJdrHBBycM5W632qUBi4E=jangcdRoefQiHzbug@mail.gmail.com>  <4E580830.4010305@panasas.com> <1314624752.2816.32.camel@twins>
In-Reply-To: <1314624752.2816.32.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2011 06:32 AM, Peter Zijlstra wrote:
> On Fri, 2011-08-26 at 13:55 -0700, Boaz Harrosh wrote:
> 
>> But this patch is for all the people and distributions that are going
>> to use the old git versions for a while, (Years).
>>
>> It is important for the Linux mailing-list review, because you get
>> patches with:
>>
>> @@@ lable out:
>> -	change foo
>> +	to bazz
>>
>> And how the hell are you suppose to know where in the file it is.
>> This is such a trivial addition, that can help unify everyone's
>> usage. I don't see the down sides.
> 
> Ah, I'm using:
> 
> # cat ~/.gitconfig 
> [diff "default"]
>                 xfuncname = "^[[:alpha:]$_].*[^:]$"
> 
> 
> For this.

It looks like a lost cause so I'll try for the last time.

Everyone is suggesting that each one do his own cooked up secrets and solutions.
And those that are stupid and know nothing like me are un-lucky. But what I'm
proposing is that by just doing a "git clone" you'll be using these settings
that we like to see, when you send us your patches.

Adding a .gitattributes file to the Linux git tree is a very simple message.
"In the linux git tree all .c and .h files are c-source files" (And git will
treat them that way)

Now that was not so hard was it? Really, no one said anything bad or negative
about the patch, only excuses how it can be achieved, very difficultly, in
another way. So for the last time:
  What are you guys afraid of? what possibly could be bad about this patch?

Sigh

Good bye to this subject
Boaz
