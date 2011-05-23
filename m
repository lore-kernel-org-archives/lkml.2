Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab1EWTN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:13:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756560Ab1EWTNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:13:54 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 12:13:29 -0700
Message-ID: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
Subject: (Short?) merge window reminder
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I've been busily merging stuff, and just wanted to send out a quick
reminder that I warned people in the 39 announcement that this might
be a slightly shorter merge window than usual, so that I can avoid
having to make the -rc1 release from Japan using my slow laptop (doing
"allyesconfig" builds on that thing really isn't in the cards, and I
like to do those to verify things - even if we've already had a few
cases where arch include differences made it less than effective in
finding problems).

And judging by the merge window so far, that early close (probably
Sunday - I'll be on airplanes next Monday) looks rather likely. I
already seem to have a fairly sizable portion of linux-next in my
tree, and there haven't been any huge upsets.

So anybody who was planning a last-minute "please pull" - this is a
heads-up. Don't do it, you might miss the window entirely.

Did I miss any major development mailing lists with stuff pending?

                       Linus

PS. The voices in my head also tell me that the numbers are getting
too big. I may just call the thing 2.8.0. And I almost guarantee that
this PS is going to result in more discussion than the rest, but when
the voices tell me to do things, I listen.
