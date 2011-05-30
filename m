Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1E3Xaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 19:30:46 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11167 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1E3Xap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 19:30:45 -0400
Date: Tue, 31 May 2011 01:22:53 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Rohit Yadav <rohityadav89@gmail.com>
cc: Borislav Petkov <bp@amd64.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Arch: x86: process: Fix a compilation warning.
In-Reply-To: <BANLkTikKjjnai0kvvdA9OdBeBhkJWT9=oQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1105310121480.8346@swampdragon.chaosbits.net>
References: <rohityadav89@gmail.com> <1306776629-13404-1-git-send-email-rohityadav89@gmail.com> <11791.1306777203@turing-police.cc.vt.edu> <BANLkTim2yJkQG=2JzFwxcAUfB3HF_m52Rg@mail.gmail.com> <13206.1306779099@turing-police.cc.vt.edu> <20110530182221.GA16214@gere.osrc.amd.com>
 <BANLkTikKjjnai0kvvdA9OdBeBhkJWT9=oQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Rohit Yadav wrote:

> > Yep, all valid points. Another one would be to search whether this got
> > already fixed before wasting effort:
> >
> > http://git.kernel.org/tip/598e887d8b01655780c81cc86a9e7820ed091580
> 
> What is the best way to search if something got fixed? There are
> plenty of repositories at git.kernel.org
> I'm using this one:
> http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
Checking linux-next is usually a good idea:
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=summary

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

