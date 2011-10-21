Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab1JUSmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 14:42:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34954 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1JUSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 14:42:45 -0400
Date: Fri, 21 Oct 2011 22:42:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrey Vagin <avagin@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
Message-ID: <20111021184239.GI31508@moon>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.670174429@openvz.org>
 <20111014171033.GC4294@google.com>
 <20111014173304.GD4294@google.com>
 <4E9E9255.7090601@parallels.com>
 <20111019182228.GJ25124@google.com>
 <20111019195632.GB14464@moon>
 <20111021182610.GB28670@google.com>
 <20111021183628.GH31508@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021183628.GH31508@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 10:36:28PM +0400, Cyrill Gorcunov wrote:
...
> 
> > I think this comes back to why one-stop-solution-in-kernel is a bad
> > idea for CR.  My impression is that when people say "that would
> > require too many small API updatesa", it usually means that they
> > haven't really thought about each necessary piece enough and just

Don't claim such things, Tejun. Yes, I'm missing a number of things
(the same applies to you as well), but this patch was not 'just a
fast way to achieve what we need'. It's rather an attempt to gather
all things I've missed and provide more robust/solid version at the
next iteration (regargless which form this patch appeared, complete
user-space solution, some kernel api extension of whatever).

> > hacked something up lumpy and fuzzy on the edges.  The thing is that
> > no matter how you lump them, those problems don't go away and
> > attacking things in small understandable API pieces not only ensures
> > the update itself makes sense and may be useful for others too but
> > also forces people to actually think about each problem.
> > 
> 

	Cyrill
