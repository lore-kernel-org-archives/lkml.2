Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1GUNFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 09:05:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50625 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab1GUNFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 09:05:16 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 21 Jul 2011 15:05:14 +0200
Message-ID: <CA+icZUVFuLszu5hBTj29M2L1OqkeNXwEV7YsvyGzo_3JL=VMQw@mail.gmail.com>
Subject: Re: Note on Linux 3.0 and the 3.1 merge window
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Please CC me I am not subscribed to LKML ]

>From [1]:

"The observation: with the upcoming version number change, the official
'git' repository is now (and has been for a week, but people probably
didn't notice) just

    git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

ie the "-2.6" thing is gone. However, the old name continues to work,
just so that nothing breaks. You don't need to really change anything,
but I thought I'd just point it out."

Nice to see you switched finally the upstream repository to a more common name.
What's with all the other repos from sub-maintainers?
I already made some suggestions in [2].

Regards,
- Sedat -

[1] http://lkml.org/lkml/2011/7/20/371
[2] http://lkml.org/lkml/2011/5/30/77
