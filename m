Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2AOCyq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 21:54:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62041 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab2AOCye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 21:54:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1201151322240.1430@tundra.namei.org>
References: <alpine.LRH.2.00.1201151322240.1430@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Jan 2012 18:54:12 -0800
X-Google-Sender-Auth: BqElVdXYy-q35fYTxFtRsH3bnq0
Message-ID: <CA+55aFwZxQkjmB6Gw7+MCY7DmyJtXjz+D6aGA7kA0X4q+qNd-g@mail.gmail.com>
Subject: Re: [GIT] Security updates for 3.3: SELinux
To: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 6:25 PM, James Morris <jmorris@namei.org> wrote:
>
>  git://selinuxproject.org/~jmorris/linux-security for-linus

Ugh. I dislike how you had an "evil merge" with no explanation about
*why* it was there. I just see the merge, and wonder what was going
on.

So I removed the merge, and tried it myself to see what the conflicts
were and what was going on. Because that's exactly the kind of thing I
do want to know about.

Please, if you do merges like this, please explain them. At the *very*
least, explain them in the merge message itself if you do them
yourself, but I actually prefer that you not do the merge at all, and
instead explain what is going on so that I can see it and react to it.

Now, if it's a trivial merge, it needs no explanation (although I also
prefer that it not be done, so that I can see even those), but
something like this where you actually need to resolve a semantic
conflict that doesn't cause any real physical conflict at all I really
prefer to be explained.

                         Linus
