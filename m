Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab1LHBQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:16:59 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44695 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258Ab1LHBQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:16:58 -0500
MIME-Version: 1.0
In-Reply-To: <20111208010251.GF2203@ZenIV.linux.org.uk>
References: <20111208010251.GF2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 Dec 2011 17:16:36 -0800
X-Google-Sender-Auth: 4u4Ihesn0i4c7rhey1Mjx2IQgGs
Message-ID: <CA+55aFyvvCh89v9eV8anN2-Pdn1LD0ncCNwi-zfsMGKw7o-_4Q@mail.gmail.com>
Subject: Re: [RFC][patch series] vfsmount gutting
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 5:02 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>        I'm *NOT* mailbombing fsdevel with that - it's a long series and
> if somebody wants a private mailbomb, that can always be arranged.  Or you
> could grab git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git
> #vfsmount-guts and use git format-patch locally...

gitweb is also not horrible for things like this. You can point your browser at

  http://git.kernel.org/?p=linux/kernel/git/viro/vfs.git;a=shortlog;h=refs/heads/vfsmount-guts

and click on the top-most commitdiff. Then you can see follow the rest
by just clicking on "parent", and you get the nicely colorized diff
with changelog entries etc. Or you can pick-and-choose based on
shortlog name.

So linear series like these can be looked at even without direct git
access. Sure, you'll get that "generating.." thing if the cache is
cold, and it all depends on how fast the net is, but it's not
necessarily any worse than being mail-bombed.

                           Linus
