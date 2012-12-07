Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab2LGKY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 05:24:26 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36942 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab2LGKYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 05:24:11 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
Date: Fri, 7 Dec 2012 11:24:04 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc8-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <201212061037.56597.Martin@lichtvoll.de> <20121207010837.GA16373@gmail.com> (sfid-20121207_103129_818557_818C137B)
In-Reply-To: <20121207010837.GA16373@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201212071124.04589.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 7. Dezember 2012 schrieb Ingo Molnar:

> * Martin Steigerwald <Martin@lichtvoll.de> wrote:
> 
> > > The thing that people are complaining about is exactly the 
> > > reverse of this. It's *protecting* us from making mistakes, 
> > > and doesn't actually add any new interfaces in itself.
> > >
> > > This is why I'm so annoyed with this stupid thread. It's 
> > > been going on forever, and reverting that change WOULD BE 
> > > OBJECTIVELY A BAD IDEA.
> > 
> > See, thats where you have a problem with "reality".
> > 
> > It seems you cannot accept the fact that some developers 
> > disliked the process in which this change was pushed. [...]
> 
> I don't think you have understood Linus's argument above.
> 
> The "process" does not change the object technical merits of a 
> patch. Ever. This patch is _good_, and objectively good. No 
> amount of 'bad process' can make this patch bad.

A patch can´t be objectively good or bad. Unlike one of you developers see
yourself as a god who actually *really* knows it. Cause individual
developers write patches, review patches, have oppinions about patches.
Anything a subject created can´t be objective at all. Saying that one
patch is *objectively* good IMO carries a message like "I know it better
than you, go away" with it.

There have been different oppinions about the patch quality. And that
is what the review process was made for. At least so I thought.

> Now, hypothetically, if this was an objectively bad patch, then 
> any "bad process" used to push it would add insult to injury and 
> it could be reason enough to flame Tytso twice as hard.

I agree to Dave´s view here. If its good, why fear and bypass the review
process upsetting other developers? Actually my argument is that using
the review process the process can be more fluent.

This way comments of other kernel developers can contribute to
make this patch better than it is currently.

And if in the end the subsystem maintainer wants to take a patch despite
NACKs, he / she can still do it. At least thats how I understood it. But
then he / shes does it openly instead of sneaking a patch in, possibly hoping
other developers do not read git logs that closely.


Granted the patch can still be improved and actually I do think the patch flag
allocation deverses a better in source code comment about it.

So I suggest:

- On a next occasion Ted (or any other developer) goes through the
review process again. Especially put controversial patches through
the review process!

- For this time discuss constructively how to make the bit reservation
patch acceptable to Dave and Christoph, i.e. by adding some documentation.
As I read out of it Dave and Christoph can basically agree with the bit
reservation. Thus there is room for improving the patch.

> But it turns out the patch was right and good, so kudos to Tytso 
> for cutting through the bike shed painting and politicks of 
> fsdevel - which "process" would have deprived us of a good 
> patch...

I am astonished by the lack of confidence you seem to put into the review
process, Ingo.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
