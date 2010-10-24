Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab0JXUrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 16:47:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932831Ab0JXUru convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 16:47:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1010232317360.6879@pobox.suse.cz>
References: <alpine.LNX.2.00.1010232317360.6879@pobox.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Oct 2010 13:47:23 -0700
Message-ID: <AANLkTinhODbKSMiwau0zRZw+5O+DPBo5UwpxM4q+Ytjb@mail.gmail.com>
Subject: Re: [GIT] trivial
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 2:39 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> please pull from 'for-next' branch at
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-next

Pulled. With one modification: I didn't take the top merge commit.

I _really_ prefer to see the clashes myself, and the extra merges just
make history less readable. So if the conflicts are trivial, please
don't pre-merge stuff - it just hides things from me.

Now, admittedly the things it hides shouldn't matter for something
like the trivial tree, but at the same time, exactly because it's the
trivial tree I would also expect the conflicts to be really trivial,
so I'd rather just have people follow the general rule of "please
don't pre-merge" regardless.

It's a good idea to perhaps do a private merge just to see how nasty
things are, and to perhaps give me a heads-up (and maybe even export
the pre-merged thing as a "btw, if you're lazy and don't care about
the conflicts, you can pull this other pre-merged branch" branch). But
on the whole, I tend to find the conflicts to be the most telling
parts of any merge, and be a good hint about what development trees
clashed with each other.

                        Linus
