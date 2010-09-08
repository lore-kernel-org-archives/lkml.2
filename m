Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0IHCUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:20:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542Ab0IHCUK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <20100907234114.GD21935@mail.oracle.com>
References: <20100907234114.GD21935@mail.oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Sep 2010 19:19:49 -0700
Message-ID: <AANLkTi=VaR=UUYh3hzKdD+tvKuuTCD4b4qufQ03AWWxQ@mail.gmail.com>
Subject: Re: [GIT PULL] ocfs2 fixes for 2.6.36.
To: Mark Fasheh <mfasheh@suse.com>, tao.ma@oracle.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 4:41 PM, Joel Becker <boel.becker@oracle.com> wrote:
>
>        Here are the ocfs2 fixes we have ready for pulling right now.  I
> have a bit of a procedural question, though.  I've been busy, so Tao was
> kind enough to take the fixes I already had and apply all the new fixes.
> He coordinated testing them and getting them ready to go upstream.
> That's why I have his git tree in the pull request below.
>        I wasn't sure how the signoffs work for this.  He's got signoffs
> on the stuff he put together, because it's coming through his tree.  My
> naive assumption is that this is the correct way to go.

The sign-off chain should basically stretch from the author to the
committer - so a good sign-off chain is one where the first sign-off
matches the author of the commit, and the last sign-off matches the
committer, and the ones in the middle are obviously the path it took
from one to the other.

However, Tao has *NOT* added sign-offs to the patches he's taken. I
didn't look at all of them, but the first few commits are all authored
(and signed off on - so far so good) by Mark Fasheh, but there is no
sign-off for Tao. So the sign-off chain is clearly not complete.

                      Linus
