Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2L1UnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:43:03 -0500
Received: from mout.gmx.net ([212.227.15.18]:63367 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab2L1UnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:43:01 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX18zp1VU2W0z+3eO2xmugan8kzyP6CSLEvNm+/IjiR
	SfAyRL8638sRRj
Date: Fri, 28 Dec 2012 21:42:53 +0100
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        anish singh <anish198519851985@gmail.com>,
        amit mehta <gmate.amit@gmail.com>,
        Henrique Rodrigues <henriquesilvar@gmail.com>,
        kishore kumar <kishoreopen@gmail.com>,
        Jonathan Neusch??fer <j.neuschaefer@gmx.net>,
        linux-kernel@vger.kernel.org, Kernelnewbies@kernelnewbies.org
Subject: Re: how to look for source code in kernel
Message-ID: <20121228204252.GA3005@debian.debian>
References: <CA+8YGd6UqfbzEHOb2NUL5p3EF4OECVq7yc2vRV3GViVT64CTbQ@mail.gmail.com>
 <20121227184034.GA2982@debian.debian>
 <CABuSbKbk5DdhvuwYUeLkm=eub1CsSaOB_oX7bkBZcAV_MNsSdg@mail.gmail.com>
 <CAK7N6vpvLrAb=sZitaEBQ6Fx4K5ehGg+LTU70hiVK=1RdE4WwQ@mail.gmail.com>
 <CAOUxTKNgs4N-M5RR6YHyGeXQqRrg0_CJpxgT2OmN_buEP+jbjQ@mail.gmail.com>
 <CAK7N6vqw+DVSVaCXqiQBVa_d2o-rg-oA5t8+6WNaZ9Mb_iQqdw@mail.gmail.com>
 <87a9syhbma.fsf@xmission.com>
 <20121228160927.GY4939@ZenIV.linux.org.uk>
 <87d2xuez32.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2xuez32.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 11:49:53AM -0800, Eric W. Biederman wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
> 
> > On Thu, Dec 27, 2012 at 11:36:13PM -0800, Eric W. Biederman wrote:
> >> But then I am probably peculiar keeping an index of the source code in
> >> my head.  When I need to look for something and I don't know where to
> >> find it I do.
> >> 
> >> git-ls-files | xargs fgrep 'struct f2fs_inode'
> >
> > What's wrong with git grep?
> 
> I haven't learned it yet.  git-ls-files is a lot better than find
> speed wise so is very much worth doing.    I haven't a clue if
> there is an advantage to git-grep, over just knowing find, xargs, and
> grep.

Brevity.

Jonathan
