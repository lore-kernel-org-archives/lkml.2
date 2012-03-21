Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2CUVDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:03:06 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41236 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2CUVDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:03:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120321202702.GA16713@ioremap.net>
References: <20120316121829.GA12685@ioremap.net> <1331904553.5406.34.camel@joe2Laptop>
 <20120316134314.GA19342@ioremap.net> <1331907127.5406.48.camel@joe2Laptop> <20120321202702.GA16713@ioremap.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Mar 2012 14:02:43 -0700
X-Google-Sender-Auth: 5iSyFTKN7QkuK3292fQQ1MdJ8HU
Message-ID: <CA+55aFwm+wfMDFwpcngKwrQEeh53JpsDXr9CPU6Xf0mfGvJHKg@mail.gmail.com>
Subject: Re: [take 3] pohmelfs: call for inclusion
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Joe Perches <joe@perches.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 1:27 PM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
>
> I'm cooking up a tree hosted on ioremap.net for tomorrow, which will be
> rebased against current tree. It will incorporate your -next pohmelfs patches.

Please don't rebase. Or if you want to make sure it's in clean form,
at least rebase it on top of something *stable*, like the v3.3
release. Not whatever random current state during the merge window.

> Then I will send next pull request to Linus "always-keeping-silence" Torvalds

I mainly just curse at people when they do something horribly bad.
It's how I vent.

I can't really say that I tend to care deeply about the innards of
some unusual filesystem that hopefully cannot possibly impact anything
else. So as long as you keep people like Al happy (or at least not
overly unhappy), I'm unlikely to worry too much.

                       Linus
