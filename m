Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0HHKyP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 06:54:15 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:45006 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab0HHKyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 06:54:10 -0400
X-ASG-Debug-ID: 1281264848-0e7200010000-xx1T2L
X-Barracuda-URL: http://10.101.1.181:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C5E8CCF.4020809@fusionio.com>
Date: Sun, 8 Aug 2010 06:54:07 -0400
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-ASG-Orig-Subj: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
Subject: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
References: <4C5BE640.2050801@fusionio.com> <AANLkTindzwVR93MN=6HpevQZh5EqfvnmbzEj9OeG-PLJ@mail.gmail.com> 	<4C5D0BE2.3050209@fusionio.com> <AANLkTi=KkPhw8nA9PmQ7D8atKjTYXVCixUt=FHHNMy+S@mail.gmail.com>
In-Reply-To: <AANLkTi=KkPhw8nA9PmQ7D8atKjTYXVCixUt=FHHNMy+S@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1281264849
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2010 05:00 PM, Linus Torvalds wrote:
> On Sat, Aug 7, 2010 at 12:31 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> Sometimes urgent patches will sit in for-linus and then I will merge
>> those in to for-2.6.36 to save Stephen the hassle of carrying conflict
>> update patches.
> 
> The merges I saw weren't even urgent, because you had never actually
> pushed them to me as such for the previous release. So both sides of
> the merge was "for-2.3.36" as far as I can tell. That's what makes me
> think there's some odd duplication of branches with no point (except
> to make the history look ugly).

No, the for-2.6.36 -> for-next was nothing urgent, just me being too
eager updating for-next. Those should never have been merges.

> Now, don't get me wrong - I _like_ branches. I love it when people
> maintain different branches for different features, and then merge
> them together in order for me to pull them (or just ask me to pull
> multiple branches). See for example merge commit  415cb47998 that
> Pekka did to create one single thing for me to pull when he had
> maintained four different topic branches. Or see the x86 "tip" pulls
> from Ingo, Thomas and Peter as an example of just asking me to pull
> multiple branches separately.

I will likely take the same approach that Pekka did, at least if there
are merge issues before sending it out.

[snip lots of good info]

>> But if you don't like that way of doing things, I will stop and just
>> keep for-2.6.X+1 patches in a branch that is based off 2.6.X and never
>> updated. I will try that for the next release and see how that goes.
> 
> It's worth trying. In fact, it might be worth trying having a few
> different branches, especially since there has been several clearly
> different development threads for the block layer. It would be
> _beautiful_ if you were to send me a couple of different pull requests
> for things like "fix writeback" and "update cfs", and they'd be
> independent. Because I think they really _are_ independent things.

Yes, there tends to be several indepent topics of development in there.
Core block bits, io scheduler, writeback, splice, driver updates, etc. I
will clearly separate them. I think the biggest part of the problem is
that it earlier was just core block and IO scheduler, but it evolved
into something more. And my current approach just doesn't work for that,
since it's gotten progressively worse over the last 2-3 releases.

> But see above. Merges per se are not evil or bad. But thoughtless
> merges are bad (and quite frankly, I don't mind a _couple_ of
> unnecessary merges. It's when I see the daily kind that I go "no,
> there's something seriously wrong here". So none of this is about hard
> rules that have to be followed 100%, it's more flexible than that).
> 
> Give it a try,

Will do :-)

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
