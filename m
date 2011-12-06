Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab1LFQgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:36:36 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53798 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1LFQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:36:35 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyFar45vTWb33FnJ1xv4zT+9XfnKBs=Xwx6-5O-RBHO4Q@mail.gmail.com>
References: <alpine.DEB.2.00.1112061619190.11925@skynet.skynet.ie>
	<CA+55aFyFar45vTWb33FnJ1xv4zT+9XfnKBs=Xwx6-5O-RBHO4Q@mail.gmail.com>
Date: Tue, 6 Dec 2011 16:36:33 +0000
Message-ID: <CAPM=9twbX+eDG=DE8FSU7HUoe1dQ=9bx1QQw5T6nKAjQdSgi4w@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> What the heck is up?

Well I do care about kexec but only due to being forced into caring
about it for a certain enterprise distro that uses it a lot, so maybe
I was a bit biased in this case, and I dislike random memory
corruptions due to my subsystem even in the kexec case. Writing a
random 0 dword somewhere in memory isn't that pretty and no fun to
track down, when the kexec looks like it succeeds.

But I've no problem leaving it sitting around until -next.

The kzalloc->kcalloc ones are partly better integer overflow defence
where userspace passes in a number of objects but I just need to make
sure they are that and not cleanups, but I haven't gotten around to it
yet.

Cool I'll resend just the Intel and obvious radeon one and stick the
others into -next.

Dave.
