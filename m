Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab0HFQUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 12:20:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759119Ab0HFQUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 12:20:03 -0400
MIME-Version: 1.0
In-Reply-To: <4C5BE229.1090801@suse.cz>
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTi=hYsksUJUsrETjFouLDiKhwQHgD2oQ7XLyrOC-@mail.gmail.com> 
	<4C5B64EA.2000804@gmail.com> <AANLkTikpsvpHuB-mWVfmqTRRMvbvhJz2LmoYBgtn4NQE@mail.gmail.com> 
	<20100806051354.GA24343@merkur.ravnborg.org> <4C5BE229.1090801@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 09:19:23 -0700
Message-ID: <AANLkTimWHnxbYzkJ1KhuS3DgTuSRz-gMnzEJvbsY835g@mail.gmail.com>
Subject: Re: [PATCH] kconfig: fix make oldconfig
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com, zippel@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 3:21 AM, Michal Marek <mmarek@suse.cz> wrote:
>
> Linus, will you apply this directly or should I apply it to the kbuild
> tree and send you a pull request?

I took it directly, since I spend a lot of time doing "make oldconfig
; make -j16" which is why I found this (after pulling, I tend verify
that at least nothing broke my _own_ configuration)

             Linus
