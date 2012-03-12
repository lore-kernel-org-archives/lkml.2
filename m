Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2CLHG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 03:06:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54438 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2CLHGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 03:06:48 -0400
MIME-Version: 1.0
In-Reply-To: <4F5D9BCF.3030302@codeaurora.org>
References: <1331524397-19783-1-git-send-email-hamo.by@gmail.com> <4F5D9BCF.3030302@codeaurora.org>
From: Yang Bai <hamo.by@gmail.com>
Date: Mon, 12 Mar 2012 15:06:28 +0800
Message-ID: <CAO_0yfPR3cvrpuOS68pYJFSHFQdfu0C=PzAA5iRu01otQTNaNg@mail.gmail.com>
Subject: Re: [PATCH] Makefile: fix error when gen TAGS
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: mmarek@suse.cz, rostedt@goodmis.org, adobriyan@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 2:46 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>
> What does ctags --version print out for you? I'm not aware of exuberant tags
> outputting files called TAGS (although etags would do that and then this
> patch wouldn't make sense).

hamo@trinity ~ $ ctags --version
Exuberant Ctags 5.9~svn20110310, Copyright (C) 1996-2009 Darren Hiebert
  Compiled: Nov  9 2011, 03:17:31
  Addresses: <dhiebert@users.sourceforge.net>, http://ctags.sourceforge.net
  Optional compiled features: +wildcards, +regex

hamo@trinity ~ $ etags --version
Exuberant Ctags 5.9~svn20110310, Copyright (C) 1996-2009 Darren Hiebert
  Compiled: Nov  9 2011, 03:17:31
  Addresses: <dhiebert@users.sourceforge.net>, http://ctags.sourceforge.net
  Optional compiled features: +wildcards, +regex

hamo@trinity ~ $ ls -l /usr/bin/etags
lrwxrwxrwx 1 root root 23 Feb  8 17:48 /usr/bin/etags -> /etc/alternatives/etags
hamo@trinity ~ $ ls -l /etc/alternatives/etags
lrwxrwxrwx 1 root root 24 Feb 15 10:06 /etc/alternatives/etags ->
/usr/bin/ctags-exuberant

So I think which kind of name Exuberant Ctags generates depends on argv[0].

>
> It would be nice if etags was updated to take care of this forward
> declaration removal. Care to send that patch?
>
Yes. I will send this patch soon.
