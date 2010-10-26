Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab0JZCHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:07:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681Ab0JZCHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:07:47 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Oct 2010 19:06:54 -0700
Message-ID: <AANLkTimNp3EhK=AsVchUMyQ__Yi4m9h1gwd6SYSvtMDA@mail.gmail.com>
Subject: Reminder: short merge window
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this is just a reminder - I'm trying to make sure that everybody is
aware of the fact that in my 2.6.36 announcement, I was talking about
trying to do a short merge window. Why?  So that I could release -rc1
by the time the kernel summit started, despite the release of 2.6.36
being delayed.

And so far, in the five days since the 2.6.36 release, we've merged
5500+ commits. That has turned my "maybe we can do a shorter merge
window" into a "we can definitely do a shorter merge window". Because
we already have enough changes, and there's almost a week to go - so I
think we're well on track for doing that. But I'll holler here once
more, just to try to make sure that nobody gets any big surprise by
such a shorter-than-usual merge window.

So for anybody out there planning on pushing things to me for this
release and haven't yet done so (and I know there are subsystems that
haven't yet, because they're in linux-next), make sure it happens this
week by Saturday (because Sunday I'm spending on a plane, and I was
tentatively planning on doing the release using the free PDX WiFi).

                                                    Linus
