Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab0HOR7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 13:59:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008Ab0HOR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 13:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimoD+-KzXVJhaKNZRvb=MkRgRUEQWnGNEwjvoRL@mail.gmail.com>
References: <AANLkTinfgXOzbqgrRY4oCGXFtKtEyJO_rvQeeEEeEZz7@mail.gmail.com> <AANLkTimoD+-KzXVJhaKNZRvb=MkRgRUEQWnGNEwjvoRL@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Aug 2010 10:58:36 -0700
Message-ID: <AANLkTik0qJ_Nd7YLii0dm6z-sbwqHLxURPaWVRKDtUSA@mail.gmail.com>
Subject: Re: [PATCH] mm: code improvement of check_stack_guard_page
To: jovi zhang <bookjovi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 10:15 PM, jovi zhang <bookjovi@gmail.com> wrote:
>
> little code improvement of check_stack_guard_page function.
> this commit is on top of commit "mm: keep a guard page below a
> grow-down stack segment" of linus.

I don't think your patch is in any way wrong, but I just checked, and
it makes absolutely zero difference to the code generation at least
for my version of gcc. The resulting assembly is identical except for
the line numbers that changed (BUG_ON() line/file information and
debug information).

So I think I prefer the shallower indentation.

                       Linus
