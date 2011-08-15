Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1HONSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:18:55 -0400
Received: from relay2.sgi.com ([192.48.179.30]:47193 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753199Ab1HONSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:18:54 -0400
Date: Mon, 15 Aug 2011 08:18:53 -0500
From: Robin Holt <holt@sgi.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, holt@sgi.com
Subject: Re: [PATCH] Remove name and email address as maintainer for SN2
Message-ID: <20110815131853.GL4926@sgi.com>
References: <1313348706-16093-1-git-send-email-Jes.Sorensen@redhat.com>
 <CA+55aFw4-3o9rX5z3Jtnim5v3K2LhsGyAbXWVG-8iyeCBjGezA@mail.gmail.com>
 <4E483C88.8090709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E483C88.8090709@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 11:22:16PM +0200, Jes Sorensen wrote:
> On 08/14/11 21:22, Linus Torvalds wrote:
> > Umm, shouldn't we mark it as unmaintained in this case?
> > 
> > Or do we have someone who has one of those and is willing to do the
> > (not very much) to make sure it keeps compiling and booting?
> > 
> >                    Linus
> 
> Hi,
> 
> We could do that too, I am not quite sure what the status is at SGI
> these days. CC'ing Robin Holt who can probably tell us whether they want
> to add a name or mark it unmaintained.

Why don't we just add me as the maintainer.  I can set up a script to
compile and boot it once a week on a few common configs.  I think I
already have that for testing the x86_64 drivers/misc/sgi-xp bits so it
should be no significant increase in work.

I will work today on getting the linux-altix@sgi.com mailing list working
again if it is not already and then ensuring I am on that list.

Thanks,
Robin

> 
> Cheers,
> Jes
> 
> 
> > On Sun, Aug 14, 2011 at 12:05 PM,  <Jes.Sorensen@redhat.com> wrote:
> >> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> >>
> >> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
> >> ---
> >>  MAINTAINERS |    1 -
> >>  1 files changed, 0 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 1d445f5..79080e0 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -5921,7 +5921,6 @@ S:        Supported
> >>  F:     drivers/net/smsc9420.*
> >>
> >>  SN-IA64 (Itanium) SUB-PLATFORM
> >> -M:     Jes Sorensen <jes@sgi.com>
> >>  L:     linux-altix@sgi.com
> >>  L:     linux-ia64@vger.kernel.org
> >>  W:     http://www.sgi.com/altix
> >> --
> >> 1.7.4.4
> >>
> >>
