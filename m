Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab2GKIOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:14:24 -0400
Received: from science.horizon.com ([71.41.210.146]:57603 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750816Ab2GKIOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:14:21 -0400
Date: 11 Jul 2012 04:14:19 -0400
Message-ID: <20120711081419.28567.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: joe@perches.com, linux-kernel@vger.kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org
Subject: Re: + checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch added to
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unser geliebter Führer schreib:
> sizeof without parenthesis is an abomination, and should never be used.

Huh.  I prefer sizeof without parens, like I prefer return without parens.

It actually annoys me when I see someone write

	return(0);

Because it's not a function (our language is too low-level to use
continuation-passing style), it's magic syntax.

Sizeof likewise.  I tend to use "p = malloc(sizeof *p)" a lot.
It just reads more nicely, to my eyes, than "p = malloc(sizeof(*p))".

If I wanted my code to be cluttered with parens, I'd write it in
Lots of Irritating Silly Parenthese.


Certainly, tha paren-less style is all over the kernel.  It's heavily
used in arch/x86/boot, for example.

I guess it's what you're used to.
