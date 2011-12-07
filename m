Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab1LGSx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:53:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48009 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680Ab1LGSx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:53:26 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.57.177]
In-Reply-To: <4EDE9289.8040903@codeaurora.org>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
 <4ECC67B9.4050306@codeaurora.org> <CAK=WgbYyrbZLmDOx8yKWwjhn2MYN8669FDRvsYZSyLj1equcTw@mail.gmail.com>
 <20111123161012.GA31423@sirena.org.uk> <4ECD5767.90307@codeaurora.org>
 <CAK=Wgba49eu_MGTWP_SND1=KDPp=MfuDyvxFGA_NND=ydqBmZA@mail.gmail.com> <4EDE9289.8040903@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 7 Dec 2011 20:53:05 +0200
Message-ID: <CAK=Wgbb1WwvzR8KVZT7aQJA6WOMJwp9qdS5HCUd6tJxgJmwQUg@mail.gmail.com>
Subject: Re: [PATCH 0/7] Introducing a generic AMP framework
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 12:09 AM, Saravana Kannan <skannan@codeaurora.org> wrote:
> Yes, I did realize it's not used in the code. I just wanted to prevent what
> I considered a misuse of "AMP". Thanks for accommodating my request.

Sure thing, and thanks for the feedback.

Dropping the 'amp' prefix also went well with my gut feeling that
remoteproc and rpmsg should again be made as independent top-level
subsystems, just like they were in the first patch set submission;
they're not really coupled, and putting them together under the 'amp'
folder just confused people and somewhat convoluted development.

I suspect that once the basic functionality will be merged, the
development of remoteproc and rpmsg will become completely orthogonal
and it would then make sense to start queueing patches separately, so
I've created two trees for them:

git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
git://git.kernel.org/pub/scm/linux/kernel/git/ohad/rpmsg.git

Though at this point splitting the patches into two separate trees
will just make it harder for people to work with the code, so both
trees currently have the entire patch-set (and some other wip stuff).

I've also created a for-next branch which I'll send to Stephen, and
then we could start doing linear development (there's a bunch of
patches I'll post soon, including stuff that was reported-by Stephen
earlier) - that will hopefully make it easier for people to use this
code, but also to review patches.

Thanks,
Ohad.
