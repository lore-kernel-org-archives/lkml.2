Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407Ab2KAXYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 19:24:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62896 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2KAXYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 19:24:35 -0400
MIME-Version: 1.0
In-Reply-To: <509301AF.6000901@zankel.net>
References: <509301AF.6000901@zankel.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Nov 2012 16:24:14 -0700
X-Google-Sender-Auth: 9POY32jDKFDKo5OfO7PYxPcbmq4
Message-ID: <CA+55aFw1ui5QgnnwgN_L2U4D_NPhrs4nKi_0xPPNjAnQ7TcW8Q@mail.gmail.com>
Subject: Re: [PULL REQUEST for 3.7-rc4] xtensa: fix syscall table and vfork,
 and switch to generic thread/execve
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 4:11 PM, Chris Zankel <chris@zankel.net> wrote:
>
>   https://github.com/czankel/xtensa-linux.git for_next

We've been here before, haven't we? There's so much wrong with this
that it's not funny.

I don't want https addresses. Yes, I suspect github uses the smart
streaming git mode, but you can't tell by the address, and it's
annoying. Github supports the native git protocol, just show that in
the address, and don't make me have to edit it for stupid reasons. So
the repository address should be

    git://github.com/czankel/xtensa-linux.git for_next

.. which brings us to the other problem. I don't do unsigned pulls
from public hosting places. Anybody can put up a github repo, and
people do.

So unless the hosting itself is limited to people I can trust some
other way (ie notably kernel.org, but there are other "controlled
hosting" places too), I really *really* want to see tags with gpg
signatures. Which the above is not.

And I know you can do them, because you've done them in the past. So
please don't continue to do the above.

               Linus
