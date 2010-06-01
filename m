Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0FATzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:55:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:39474 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab0FATzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:55:36 -0400
Message-ID: <4C0565AC.8020205@suse.cz>
Date: Tue, 01 Jun 2010 21:55:24 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       a.beregalov@gmail.com, andi@firstfloor.org, dzickus@redhat.com,
       fejes@joco.name, g.liakhovetski@gmx.de, gthelen@google.com,
       hschauhan@nulltrace.org, hui.zhu@windriver.com, jan3sobi3ski@gmail.com,
       jay@goldhive.com, jgunthorpe@obsidianresearch.com, jkacur@redhat.com,
       joe@perches.com, kirr@mns.spb.ru, lizf@cn.fujitsu.com,
       nir.tzachar@gmail.com, rabin@rab.in, rientjes@google.com,
       roland@redhat.com, saalwaechter@gmail.com, shemminger@vyatta.com,
       tabbott@ksplice.com, u.kleine-koenig@pengutronix.de, vbendeb@google.com,
       vda.linux@googlemail.com, wuzhangjin@gmail.com, xt28@gmx.de
Subject: Re: [GIT] kbuild changes for 2.6.35
References: <20100527144459.GA14513@sepie.suse.cz> <alpine.LFD.2.00.1005300921000.4639@i5.linux-foundation.org> <20100531120223.GA11700@sepie.suse.cz> <alpine.LFD.2.00.1006010823080.3637@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006010823080.3637@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1.6.2010 17:32, Linus Torvalds wrote:
> No, the commits themselves are likely fine, although for the future it 
> really would be good to make things like that more descriptive. I just 
> want people to try to argue for _why_ I should do a pull, and _what_ I'm 
> getting in their "please pull" thing.
> 
> It's not always necessary, and some people do it better than others. For 
> an example of a really good pull request, look at the ones David Miller 
> sends me for networking - they explain what's going on in the pull, so 
> it's always easy to pull them because just the request makes me feel like 
> David is really on top of things, and lets me have some 30'000 ft overview 
> of what's going on.

OK, I'll try to do better job next time. I'm also going to use different
branches for kbuild / kconfig / trivial stuff like .gitignore / etc from
now on, so that you don't get a all-or-nothing pull request in the next
merge window (something that Sam suggested).


> At the same time, in many cases I obviously pull _without_ any kind of 
> real explanation - and that tends to be especially true with maintainers 
> that I've worked with for a long time, or areas that are so specialized 
> that they are almost self-explanatory (let's be honest: when a filesystem 
> maintainer asks me to pull their special filesystem, I'm perfectly happy 
> with the overview of "30 changesets to XFS", and there's no need for much 
> explanation, although a rough overview of what's been going on is always 
> good to see).
> 
> So the reason I ask for explanations for kbuild is that not only have we 
> had different maintainers, it's an area that affects a lot of different 
> things and has historically had issues with odd architectures or old 
> binutils tools etc.

I see. Thanks a lot for pulling the changes now.

Michal
