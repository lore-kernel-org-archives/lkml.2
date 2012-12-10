Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab2LJVMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:12:34 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:44393 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2LJVMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:12:33 -0500
X-Auth-Info: Y5HoKb0XfvW0lVhwV9uzsKJEa3H81XI16WWeGyQ36zo=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Missing tags in my local stable git repo
References: <1355160900.17101.229.camel@gandalf.local.home>
	<1355165264.17101.233.camel@gandalf.local.home>
	<20121210190247.GA32119@kroah.com>
	<1355166920.17101.239.camel@gandalf.local.home>
	<CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
	<1355172274.17101.250.camel@gandalf.local.home>
X-Yow: Put FIVE DOZEN red GIRDLES in each CIRCULAR OPENING!!
Date: Mon, 10 Dec 2012 22:12:29 +0100
In-Reply-To: <1355172274.17101.250.camel@gandalf.local.home> (Steven Rostedt's
	message of "Mon, 10 Dec 2012 15:44:34 -0500")
Message-ID: <m2vcc9oblu.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> [remote "origin"]
>         fetch = +refs/*:refs/*
>         mirror = true
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> [remote "stable"]
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>         fetch = +refs/heads/*:refs/heads/*

This is your problem.  When fetching from origin all references
(including tags) not part of origin are removed.  When you mirror a repo
you cannot have another remote in the same repo.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
