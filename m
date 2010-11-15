Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab0KOWQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:16:52 -0500
Received: from tundra.namei.org ([65.99.196.166]:35656 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676Ab0KOWQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:16:51 -0500
Date: Tue, 16 Nov 2010 09:16:26 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Eric Paris <eparis@parisplace.org>, Joe Perches <joe@perches.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
In-Reply-To: <AANLkTin7Sfx5rnU3u7da5bQQiLTj9geOMht-x6z6kvid@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1011160914030.29867@tundra.namei.org>
References: <1289669176.16461.12.camel@Joe-Laptop> <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com> <1289677904.16461.82.camel@Joe-Laptop> <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com> <AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com>
 <AANLkTimoFGqKDYe24uc_2EHk-MLqxc4GGCCe7hPRJqbJ@mail.gmail.com> <AANLkTin7Sfx5rnU3u7da5bQQiLTj9geOMht-x6z6kvid@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Linus Torvalds wrote:

> On Mon, Nov 15, 2010 at 9:34 AM, Eric Paris <eparis@parisplace.org> wrote:
> >
> > I'm sure somebody somewhere hates it, but I was thinking something
> > like the attached.
> 
> I certainly like it. If the old rule should have been that you _have_
> to call cap_syslog(), then just eviscerating that entirely and putting
> it in the generic code is definitely the right thing.
> 
> Anyway, I wanted to do -rc2 yesterday, but I don't really want this
> kernel build problem to remain (even if it's not a very relevant
> config for most people).
> 
> So if people can quickly agree on this, I'll take it and do -rc2 later
> today, otherwise I'll do Joe's trivial patch as a stop-gap measure
> pending approval for cleanup/fixing the security interfaces.

Looks good to me:

Acked-by: James Morris <jmorris@namei.org>


(I'd really like to see new security features get fully reviewed on the 
LSM list and bake in -next for a while in the future, no matter how 
obviously correct they seem).


-- 
James Morris
<jmorris@namei.org>
