Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1AJQo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:44:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622Ab1AJQoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:44:25 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101091110520.5270@tiger>
References: <alpine.DEB.2.00.1101091110520.5270@tiger>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Jan 2011 08:44:03 -0800
Message-ID: <AANLkTim0UBNG6bVgBDQsrBhVjS0FSdLbwaipBZGkTeWF@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.38
To: Pekka Enberg <penberg@kernel.org>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 9, 2011 at 1:13 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> It's been rather quiet for slab allocators this merge cycle. There's only
> few cleanups here. The bug fixes were merged in v2.6.37 already. As they
> were cherry-picked from this branch, they show up in the pull request
> (what's up with that btw).

For the "what's up with that btw" department:

A cherry-pick really is nothing but "apply the same patch as a
different commit".

So there is no way to say "this is already there" - because it really
isn't. It's a totally different thing. In fact, it would be very wrong
to filter them out, both from a fundamental design standpoint, but
also from a usability/reliability standpoint: cherry-picks are by no
means guaranteed to be identical to the source - like any "re-apply
the patch in another place" model, the end result is not at all
guaranteed to be semantically identical simply due to different bases:
the patches may not even be identical, and even if they are, the
results of the code may depend on what else is going on.

So don't think of cherry-picks as "the same commit". It's not, and it
never will be. It's a totally separate commit, they just share some
superficial commonalities.

                    Linus
