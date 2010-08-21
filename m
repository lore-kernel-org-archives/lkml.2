Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab0HUUFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 16:05:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:49903 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab0HUUFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 16:05:30 -0400
Date: Sat, 21 Aug 2010 22:05:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH,TRIVIAL] Replace Configure with Enable in description
	of MAXSMP
Message-ID: <20100821200528.GA27421@merkur.ravnborg.org>
References: <20100821193241.GB4760@const.famille.thibault.fr> <AANLkTi=Pha8jRFhr+kQfh9doKZDW-=VHq2KqNxXaq6ts@mail.gmail.com> <20100821195559.GC4760@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821195559.GC4760@const.famille.thibault.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Ah, I didn't realize you scripts include the subject topic too. Maybe it
> should be said in SubmittingPatches that the "summary phrase" shouldn't
> be repeated in the body.

>From said document:
15) The canonical patch format

The canonical patch subject line is:

    Subject: [PATCH 001/123] subsystem: summary phrase

The canonical patch message body contains the following:

  - A "from" line specifying the patch author.

  - An empty line.

  - The body of the explanation, which will be copied to the
    permanent changelog to describe this patch.

  - The "Signed-off-by:" lines, described above, which will
    also go in the changelog.

  - A marker line containing simply "---".

  - Any additional comments not suitable for the changelog.

  - The actual patch (diff output).

That should do it. We cannot tell what should NOT be done.

If you use git then it is trivial to commit your changes and
generate patches using "git format-patch ..."

	Sam
