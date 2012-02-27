Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2B0QYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:24:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40552 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab2B0QYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:24:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.84.170 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <6BDEC6CA-36B6-4CA7-88C3-02FD1A0B2526@cam.ac.uk>
References: <6BDEC6CA-36B6-4CA7-88C3-02FD1A0B2526@cam.ac.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Feb 2012 08:23:52 -0800
X-Google-Sender-Auth: njXQ_Qbq2eYOvvrjhJ4TgVTXrB0
Message-ID: <CA+55aFy5qXa-5KKABqgNoE=dhK-8ef45EbSGwzjGPEvxf1q1Gw@mail.gmail.com>
Subject: Re: [git pull] Trivial NTFS and LDM changes.
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ntfs-dev <linux-ntfs-dev@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 2:26 AM, Anton Altaparmakov <aia21@cam.ac.uk> wrote:
>
> PS. None of this is especially urgent so if you prefer me to re-send when the
> next merge window opens please let me know.  I just thought these things
> are so trivial we might as well get them in now.

Hey, it was small and removed more lines than it added, so I pulled it.

Sadly, I didn't *look* at it until after I had already pushed out.

*THESE* things would have made me unpull it immediately, if I hadn't
done my test compile and pushed things out:

commit f621c5334396fd153cd882ea92466823b7e7b821
Merge: 0afa1b62e332 500dd2370e77
Author: Anton Altaparmakov <anton@tuxera.com>
Date:   Mon Feb 27 09:01:22 2012 +0000

    Merge branch 'master' of /Volumes/CaseSensitiveDisk/linux

commit 0afa1b62e33250d4777c5803a98ae69fbe872061
Merge: 97387e3baaf3 bb4c7e9a9908
Author: Anton Altaparmakov <anton@tuxera.com>
Date:   Fri Feb 24 09:39:16 2012 +0000

    Merge branch 'master' of /Volumes/CaseSensitiveDisk/linux

There's two of those *stupid* merges that have no reason for existing,
no explanation, and are just ugly.

Don't do this, guys!

And if you know you do these by mistake, just get the current version
of git *pronto*, and install that instead of (or in addition to: "make
install" just installs it in your ~/bin directory, so if you make your
PATH look there first, you don't need anything else) your distro
version of git.

That will now bring up an editor for your merges, and maybe that will
make you go "Oh, this is f*cking STUPID", and realize that you
shouldn't be doing that merge!

Christ. I really don't like stupid unnecessary merges. And when they
are from "master" of some random badly named repository, I like them
even less. The above is really just a f*cking abomination, and says
"somebody is doing something horribly wrong".

                     Linus
