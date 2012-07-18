Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2GRLJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:09:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61328 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2GRLJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:09:06 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 18 Jul 2012 13:09:04 +0200
Message-ID: <CA+icZUVPS=xkm0+=6JZPGmT9BRJgbGav3AHCgpYuvt-71+xhmg@mail.gmail.com>
Subject: linux-next: Trees and MAINTAINERS of random drivers?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while digging into an issue with the random driver [0] yesterday, I
checked today the "Next/Trees" and random driver related informations
in "MAINTAINERS" files.
...and have some questions.

David's random tree is listed in linux-next [1]:

26 dwmw2           git
git://git.infradead.org/users/dwmw2/random-2.6.git#master

But [2] shows me that there were no activities in this tree for about 3 years.
Is that still valid and/or should that tree be dropped?
[ Sorry, for nitpicking but suffix "-2.6" should simply die in GIT
repo and branch names after introduction of upstream's linux.git. ]

[3] lists Ted as new random driver maintainer, but in [4] I found Matt
as maintainer:

5656 RANDOM NUMBER DRIVER
5657 M:      Matt Mackall <mpm@selenic.com>
5658 S:      Maintained
5659 F:      drivers/char/random.c

I do not think that this is still correct and furthermore in Ted's
random.git#dev tree I see commits changing "drivers/char/random.c"
file.
So, that above block should IMHO be dropped and "F:
drivers/char/random.c" added to [6]?

Just noticed while looking into linux-next and the recent random
revival from Ted.

Thanks to old and new random maintainers for their great work!

Kind Regards,
- Sedat -

[0] http://marc.info/?l=linux-next&m=134252508224850&w=2
[1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=Next/Trees;hb=HEAD#l26
[2] http://git.infradead.org/users/dwmw2/random-2.6.git
[3] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=ec1b70506a9ec3be8191ddb2f4de9ac066e6a431
[4] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=MAINTAINERS;hb=HEAD#l5656
[5] http://git.kernel.org/?p=linux/kernel/git/tytso/random.git;a=shortlog;h=refs/heads/dev
[6] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=MAINTAINERS;hb=HEAD#l3170
