Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2B0S6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:58:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48067 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2B0S6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:58:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.14.130.208 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F4BD24C.6000307@suse.cz>
Date: Mon, 27 Feb 2012 19:58:20 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>,
        gigaset307x-common@lists.sourceforge.net
Subject: Re: "whitespace coding style cleanup" broke coding style
References: <4F4B45F6.4090706@suse.cz> <1330361549.9942.7.camel@joe2Laptop>  <4F4BB983.8020608@suse.cz> <1330363627.9942.16.camel@joe2Laptop>
In-Reply-To: <1330363627.9942.16.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 06:27 PM, Joe Perches wrote:
> On Mon, 2012-02-27 at 18:12 +0100, Jiri Slaby wrote:
>> The patch should not
>> touch the code at all. It is obviously totally broken. In a separate
>> patch you might do s@,@;@ instead.
>
> The code in either form is neither broken nor
> incorrect.  It's just "out of style".
> Emacs did made it consistent.

I understand that it is correct according to the style. It is not 
correct in that how humans read it.

>> Hmm, but did not we conclude some time ago that we will not touch code
>> just to perform a whitespace cleanup?
>
> It's a prelude to other patches so actually
> that's done quite a lot.   git blame -w
> doesn't even show my name on any of the
> code in this patch.

Yeah, but git merge or rebase do not cope with this. That is the problem 
I am writing about.

>>> It was a first pass and an overall improvement.
>>
>> I hope no other passes are going to happen there or anywhere in TTY
>> drivers. I really do not want to solve zillion collisions in my ~100
>> local patches due to whitespace changes, sorry.
>
> Perhaps you should submit your ~100 patches sooner
> rather than later.  That's a lot of changes that
> could have any number of collisions.

No, sorry, I do not send patch series which are not reviewed by me with 
at least 2 weeks distance. Anyway the point is elsewhere.

To emphasize: I do not mind random changes on random files. That is easy 
to fix. I mind whitespace cleanups over _whole_ subtrees.

>> Yes, but it does not pass our brain, does it? One should throw
>> "checkpatch --file" or alike away, finally.
>
> Perhaps you might notice I did not use checkpatch
> as a guide nor as a criteria for submission.

Ok, but you still fit in "or alike" above.

> It was ~5MB patch btw.  Compilation was done to
> verify lack of object delta only.

I see. Sorry to say that, but 5MB of whitespace cleanup is purely 
insane. Do not tell me that you are going to fix/change something in all 
the files. And even if that is the case, fixes go first so that people 
are able to backport to stable if they fit there.

Please, search archives for similar discussions. I do not want to repeat 
that.

> Thanks for noticing the oddly formatted code.
> I'll send a patch to fix it.

It looks good. ACK. [Although I am sad I will have to solve that 
conflict once more :(.]

thanks,
-- 
js
suse labs
