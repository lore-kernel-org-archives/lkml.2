Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1APUFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 15:05:44 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16202 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab1APUFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 15:05:42 -0500
Date: Sun, 16 Jan 2011 21:05:41 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Rob Landley <rlandley@parallels.com>
cc: linux-kernel@vger.kernel.org, tglx@linuxtronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org,
        "K. Y. Srinivasan" <ksrinivasan@novell.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] Use sed instead of perl to generate
 x86/kernel/cpu/capflags.c.
In-Reply-To: <4D334E1E.7090708@parallels.com>
Message-ID: <alpine.LNX.2.00.1101162103450.13377@swampdragon.chaosbits.net>
References: <4D334E1E.7090708@parallels.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Jan 2011, Rob Landley wrote:

> From: Rob Landley <rlandley@parallels.com>
> 
> Generate capflags.c with sed (POSIX 2008) instead of perl.
> 

While I'm not personally a great perl fan, this still begs the 
question, why?

We already depend on perl for other stuff, so why replace something that 
works with something that may or may not work?


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

