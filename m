Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab2DDQoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:44:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61020 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab2DDQoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:44:12 -0400
MIME-Version: 1.0
In-Reply-To: <4F7C7907.3090808@gmail.com>
References: <20120401125741.GA7484@p183.telecom.by> <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com>
 <4F7A3CC2.1040200@zytor.com> <CAOPLpQebqKED5G1nti6i=JLZ+A6df2UdA86RVEv1Er7hw7KFpQ@mail.gmail.com>
 <4F7C7907.3090808@gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 4 Apr 2012 12:43:51 -0400
Message-ID: <CAOPLpQfowVbAfY5utOa4pYDkA+AtLGU0zMLC5Eq5oH=zVrVC6Q@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 12:38, KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:
> As far as I understand, any major open source project don't use
> posix_spawn().
> Please remind, I'm talking about real world issue.

This doesn't mean they shouldn't.  If you require code to be changed
anyway let them change to something which doesn't require more cruft
in the kernel.  The limitations you cited are irrelevant for
posix_spawn.  And perhaps there will be actually spawn support in the
kernel which would make dealing with OOM situations and non-overcommit
much easier.
