Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1IEU10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 16:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab1IEU1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:27:16 -0400
Message-ID: <4E65307F.5020103@redhat.com>
Date: Mon, 05 Sep 2011 17:26:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        git@vger.kernel.org
Subject: Re: Linux 3.1-rc5
References: <CA+55aFxDjVJwbpP5YT4o=qud=OcxtT3Ry4HfCtW-FvNdj+RFeQ@mail.gmail.com>
In-Reply-To: <CA+55aFxDjVJwbpP5YT4o=qud=OcxtT3Ry4HfCtW-FvNdj+RFeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-09-2011 20:27, Linus Torvalds escreveu:

> One thing to note: If you just do
> 
>    git pull https://github.com/torvalds/linux.git
> 
> you probably won't get the tags, since it's not your origin branch. So do
> 
>    git fetch --tags<...>
> 
> too, so that you get not only the actual changes, but the tag that you
> can verify too.
> 

It would be great if "git remote update" could also verify the tag
signature (if present), as most of us just do a "git remote update".

Maybe an extra parameter for git config remote.tagopt?

Ok, if in doubt, we can always use git tag -v <new tag>, but doing
it automagically would help us to detect if a git tag got mangled
by some  at the moment we update our trees, with seems to be
a good idea.

Thanks,
Mauro
