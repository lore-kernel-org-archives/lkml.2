Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab1L3Jrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 04:47:39 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:52576 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431Ab1L3Jrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 04:47:35 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtkKACeH/U5tgySC/2dsb2JhbABCqzuBN4EGgXIBAQQBMgEjIwULCANGFCUDIYgNAga2AROLfASVAZI2
Date: Fri, 30 Dec 2011 10:47:33 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Mingarelli@infomag.iguana.be, Thomas <Thomas.Mingarelli@hp.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.1-rc7 - Fixes
Message-ID: <20111230094733.GY23376@infomag.iguana.be>
References: <20111227194444.GV23376@infomag.iguana.be> <CA+55aFzk_3VqxbOaAphbVacmi1fBFqxA-nSYLpXDztbihJ3U5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzk_3VqxbOaAphbVacmi1fBFqxA-nSYLpXDztbihJ3U5Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > Please pull from 'master' branch of
> >        git://www.linux-watchdog.org/linux-watchdog.git
> >
> > This will update the following files:
> 
> You have done something absolutely horrible with that git repository.
> 
> The default HEAD does not actually point to the master branch, so the
> thing you asked me to pull
> ("git://www.linux-watchdog.org/linux-watchdog.git" without any branch
> name) does not actually result in what you claimed it would result in.
> 
> It looks like HEAD points to "linux-next".

HEAD was indeed pointing to linux-next. My apologies for that.
I just fixed it.

> Sure, the above is technically a valid git repository, but (a) it's
> crazy and (b) if you really want to do that, then you had better
> actually mention the branch explicitly in the pull line too, ie
> 
>   Please pull ..
> 
>      git://www.linux-watchdog.org/linux-watchdog.git master
> 
> so that when I cut-and-paste, I actually get the right branch.

I'll make sure that you get future requests in this format.

Will I resent it or will you just do a pull from:
	git://www.linux-watchdog.org/linux-watchdog.git master

Kind regards,
Wim.

