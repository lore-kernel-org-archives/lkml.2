Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1ASFK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:10:58 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39983 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1ASFK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:10:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WIv4k7vRh1hnxg8nd7VH6DHqgYKn12gamYZQYQ5Yzuq0VTXC48uEYHEOOnxE6JxQ9J
         52ZogNgDy8M2iMNSSz37AnGIE2WpnaQg0ZtElWeKCtv/HmQAKQ8Kk5Zu77Ej4THd9cqe
         jvjNJVjJG/IShyJvMcjAjhxzpFHinQ851sews=
Date: Wed, 19 Jan 2011 00:10:49 -0500
From: nobody <darwinskernel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc1
Message-ID: <20110119051049.GA2536@WALL-E>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <AANLkTimp0UcWi68N5Jv_hUww9PhGVgCzY0qYLETc8Dj_@mail.gmail.com>
 <1161CC5A-C8CA-477E-B2CE-7870F8E634EE@gmail.com>
 <AANLkTin+Div6HoAJdFOfqRFSMyxqx7ft7mcteXomaV_Y@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin+Div6HoAJdFOfqRFSMyxqx7ft7mcteXomaV_Y@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But you can get git, and do
> 
>    git shortlog v2.6.37..v2.6.38-rc1
> 
> to get the shortlog. Or you can download the whole changelog from
> kernel.org next to the kernel sources. The git approach is better,
> because you can ask for the log for just specific files or
> subdirectories that you are interested in, which turns the flood into
> something much more manageable.

i wish i could do that for everything. i am pulling up to 500MiB every
-rc cycle and mostly codes for hardwares i don't have. not just that
sometimes changes to even pertain to my machine (so no, `git clone
--depth 1' is not what i have in mind).
it would be nice to have a module or a script for git that would work
with kconfig. so instead of pull-config-compile, one would
config-pull-compile. (ok some initial pull for kconfig stuff first but that
would be all). 
i asked this from folks at #git channel and they suggested, because
of the way git works, "git thinks in terms of trees not directories", i
should ask you to see if it's doable?
needless to say that this should also help with the load on kernel.org as
well, since i imagine people that pull from git to compile their own
kernel by definition don't need everything.

regards,
