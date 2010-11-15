Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab0KORrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:47:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933194Ab0KORrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:47:18 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimoFGqKDYe24uc_2EHk-MLqxc4GGCCe7hPRJqbJ@mail.gmail.com>
References: <1289669176.16461.12.camel@Joe-Laptop> <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
 <1289677904.16461.82.camel@Joe-Laptop> <AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>
 <AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com> <AANLkTimoFGqKDYe24uc_2EHk-MLqxc4GGCCe7hPRJqbJ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Nov 2010 09:41:25 -0800
Message-ID: <AANLkTin7Sfx5rnU3u7da5bQQiLTj9geOMht-x6z6kvid@mail.gmail.com>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
To: Eric Paris <eparis@parisplace.org>
Cc: Joe Perches <joe@perches.com>, Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 9:34 AM, Eric Paris <eparis@parisplace.org> wrote:
>
> I'm sure somebody somewhere hates it, but I was thinking something
> like the attached.

I certainly like it. If the old rule should have been that you _have_
to call cap_syslog(), then just eviscerating that entirely and putting
it in the generic code is definitely the right thing.

Anyway, I wanted to do -rc2 yesterday, but I don't really want this
kernel build problem to remain (even if it's not a very relevant
config for most people).

So if people can quickly agree on this, I'll take it and do -rc2 later
today, otherwise I'll do Joe's trivial patch as a stop-gap measure
pending approval for cleanup/fixing the security interfaces.

                              Linus
