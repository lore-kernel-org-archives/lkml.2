Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2LUBuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 20:50:54 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:47068 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2LUBut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 20:50:49 -0500
MIME-Version: 1.0
In-Reply-To: <1356043138.2592.10.camel@localhost>
References: <1356043138.2592.10.camel@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Dec 2012 17:50:26 -0800
X-Google-Sender-Auth: Ptg_ou1o0i3CCKrZuvUKU2FUzO0
Message-ID: <CA+55aFxGi5qMounLCpJGa7vYxx+O3ho1xVPuHxOg3F24DTu2cg@mail.gmail.com>
Subject: Re: [GIT PULL] notification tree changes for 3.8
To: Eric Paris <eparis@redhat.com>, Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 2:38 PM, Eric Paris <eparis@redhat.com> wrote:
> I believe you would get a build failure after this pull due to the
> addition of procfs information for *notify fds.  The attached patch from
> sfr should be applied during the merge to change the spin_lock in that
> patch to the mutex in this patch.

I'm not going to bother pulling this.

It's coming in late in the merge window, it has been rebased days ago,
and it changes fundamental infrastructure.

This has been a huge merge window, and this is just too late and too
surprising. The commits are marked as being written 18 months ago, but
then the commit date is after the merge window started, and sent the
day before it closes.

WTF? If they've waited 18 months, there cannot be this kind of
last-minute hurry now. Why did you wait until the last minute?

                Linus
