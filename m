Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab1E3UAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:00:36 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:39344 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751884Ab1E3UAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:00:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZXG3KqHuSm21IPqb2IAnfzd8tbhScMhPf+iBPf7r8kC3gxRqn2btPzQOoMWw0LTs92lX1WNPw7EnwY9Lb+I7XSNfkl3TlQSuPOYBsEB25a/p7waqz9p+i5ChAOPdW3qc;
Date: Mon, 30 May 2011 13:00:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Rohit Yadav <rohityadav89@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Arch: x86: process: Fix a compilation warning.
Message-Id: <20110530130032.a4ec9757.rdunlap@xenotime.net>
In-Reply-To: <BANLkTikKjjnai0kvvdA9OdBeBhkJWT9=oQ@mail.gmail.com>
References: <rohityadav89@gmail.com>
	<1306776629-13404-1-git-send-email-rohityadav89@gmail.com>
	<11791.1306777203@turing-police.cc.vt.edu>
	<BANLkTim2yJkQG=2JzFwxcAUfB3HF_m52Rg@mail.gmail.com>
	<13206.1306779099@turing-police.cc.vt.edu>
	<20110530182221.GA16214@gere.osrc.amd.com>
	<BANLkTikKjjnai0kvvdA9OdBeBhkJWT9=oQ@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011 01:22:54 +0530 Rohit Yadav wrote:

> > Yep, all valid points. Another one would be to search whether this got
> > already fixed before wasting effort:
> >
> > http://git.kernel.org/tip/598e887d8b01655780c81cc86a9e7820ed091580
> 
> What is the best way to search if something got fixed? There are
> plenty of repositories at git.kernel.org
> I'm using this one:
> http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

There are > 100 git trees, so just pick a few, like acpi, tip, arm, etc.,
and check them (I wouldn't expect anyone to check _all_ of them).

Or you could check mailing list archives: see here:
http://marc.info/?l=linux-kernel&m=130675351609350&w=2

It would be good IMO if -tip had a commits mailing list like
stable and -mm and mainline do.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
