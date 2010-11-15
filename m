Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab0KOWwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:52:24 -0500
Received: from tundra.namei.org ([65.99.196.166]:58780 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758687Ab0KOWwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:52:22 -0500
Date: Tue, 16 Nov 2010 09:51:59 +1100 (EST)
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
In-Reply-To: <AANLkTi=2Q3XUvFyk+s1aAOWH5bT7e6om8QaC=AOuLkLj@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1011160950280.30359@tundra.namei.org>
References: <1289669176.16461.12.camel@Joe-Laptop> <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com> <1289677904.16461.82.camel@Joe-Laptop> <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com> <AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com>
 <AANLkTimoFGqKDYe24uc_2EHk-MLqxc4GGCCe7hPRJqbJ@mail.gmail.com> <AANLkTin7Sfx5rnU3u7da5bQQiLTj9geOMht-x6z6kvid@mail.gmail.com> <alpine.LRH.2.00.1011160914030.29867@tundra.namei.org> <AANLkTi=2Q3XUvFyk+s1aAOWH5bT7e6om8QaC=AOuLkLj@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Linus Torvalds wrote:

> On Mon, Nov 15, 2010 at 2:16 PM, James Morris <jmorris@namei.org> wrote:
> >
> > Acked-by: James Morris <jmorris@namei.org>
> 
> Ok, now we need sign-off and changelog from Eric... Ping?
> 
> > (I'd really like to see new security features get fully reviewed on the
> > LSM list and bake in -next for a while in the future, no matter how
> > obviously correct they seem).
> 
> Hey, I can still just do the trivial "just fix the build" part without
> actually cleaning up the security layer for -rc2. Just let me know
> which one you'd prefer.

I'd prefer to get the right code in (Eric's).


- James
-- 
James Morris
<jmorris@namei.org>
