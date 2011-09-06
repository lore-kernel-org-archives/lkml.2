Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1IFHXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 03:23:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56302 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab1IFHXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 03:23:41 -0400
X-Sasl-enc: ZS6KzkKj/lW02Ap48BA1dk3dtV0YtrslZ9C7k5GqRb4l 1315293820
Message-ID: <4E65CA7B.5050803@drmicha.warpmail.net>
Date: Tue, 06 Sep 2011 09:23:39 +0200
From: Michael J Gruber <git@drmicha.warpmail.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        git@vger.kernel.org
Subject: Re: Linux 3.1-rc5
References: <CA+55aFxDjVJwbpP5YT4o=qud=OcxtT3Ry4HfCtW-FvNdj+RFeQ@mail.gmail.com> <4E65307F.5020103@redhat.com>
In-Reply-To: <4E65307F.5020103@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab venit, vidit, dixit 05.09.2011 22:26:
> Em 04-09-2011 20:27, Linus Torvalds escreveu:
> 
>> One thing to note: If you just do
>>
>>    git pull https://github.com/torvalds/linux.git
>>
>> you probably won't get the tags, since it's not your origin branch. So do
>>
>>    git fetch --tags<...>
>>
>> too, so that you get not only the actual changes, but the tag that you
>> can verify too.
>>
> 
> It would be great if "git remote update" could also verify the tag
> signature (if present), as most of us just do a "git remote update".

...when you should "git fetch --all" ;)

> Maybe an extra parameter for git config remote.tagopt?
> 
> Ok, if in doubt, we can always use git tag -v <new tag>, but doing
> it automagically would help us to detect if a git tag got mangled
> by some  at the moment we update our trees, with seems to be
> a good idea.

The update hook (if you want to reject falsified tags) or post-update
hook (if you want to be warned) is the perfect place for this. It would
be worth amending the standard update hook, me thinks, after removing
its insisting on a project description, and maybe switching the defaults.

Michael
