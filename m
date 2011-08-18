Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab1HRTMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:12:52 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:35656 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab1HRTMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:12:49 -0400
Message-ID: <4E4D642F.3010909@nod.at>
Date: Thu, 18 Aug 2011 21:12:47 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH 00/91] pending uml patches
References: <E1Qu7nv-0007OP-3E@ZenIV.linux.org.uk>
In-Reply-To: <E1Qu7nv-0007OP-3E@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

Am 18.08.2011 20:58, schrieb Al Viro:
>
> My apologies for mailbomb from hell.  *All* this stuff is available in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/um-header.git/ #master,
> but since uml folks had been stuck with mail and patch for a long time...

Have you touched your patches since yesterday?
I've already pulled and uploaded them to my shiny new git repo at:
git://git.kernel.org/pub/scm/linux/kernel/git/rw/linux-um.git unstable

Due to the current mirroring problems with git.kernel.org I have not 
sent made it public.
Sorry for that, I screwed it. :-(

> Anyway, most of the stuff in this pile is merging, cleaning and mutilating
> subarchitecture-related code in arch/um.  By the end of it we have x86
> bits largely merged between 32bit and 64bit variants and taken to arch/x86/um;
> headers seriously cleaned up and mostly free of x86-isms now (not completely -
> we still have page size dependencies in there).
>
> Beginning of the series are pure build and driver fixes; those should go to
> Linus before 3.1-final, IMO.

Okay.

> As far as I know, there's no regressions introduced by that pile; testing
> and comments would be, of course, welcome.
>

There was a small build regression, I've already fixed it!

Thanks,
//richard
