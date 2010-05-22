Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935702Ab0EVBTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 21:19:10 -0400
Received: from mail.atheros.com ([12.36.123.2]:45648 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376Ab0EVBTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 21:19:05 -0400
Date: Fri, 21 May 2010 18:19:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] compat-wireless: add linux-next-pending, crap patch
 dirs and nagometer
Message-ID: <20100522011902.GB2202@tux>
References: <1274489059-1019-1-git-send-email-lrodriguez@atheros.com>
 <1274490936.3439.14.camel@ct>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1274490936.3439.14.camel@ct>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 06:15:36PM -0700, Pavel Roskin wrote:
> On Fri, 2010-05-21 at 20:44 -0400, Luis R. Rodriguez wrote:
> > Sometimes you have no other option but to carry around patches.
> > This can happen for a variety of reasons. Ultimately testing of code
> > cannot happen on the kernel maintainer's clock but on your own.
> > 
> > This expands the idea of the linux-next-cherry-pick patch directory
> > on compat-wireless to also allow for patches to be merged which are
> > posted to some mailing list but pending merge due to some reasons
> > (merge window is a good example). It also adds a crap patch directory
> > for those really nasty situations you can run into where you have
> > no other option but to give someone a release with some delta even
> > if the patch is not yet posted anywhere.
> 
> Please replace "crap" with some more descriptive name, like
> "unpublished".  It's better to be friendly to users and express
> frustration in a different way.

I'm using crap to keep focus on not-yet-merged-or-posted code, I refuse
to be friendly to that type of code. I want the users to be frustrated
about that code.

> > +	printf "${RED}%10s${NORMAL} - Crap changes not yet posted\n" $2
> > +	printf "${RED}%10s${NORMAL} - Crap additions not yet merged\n" $3
> > +	printf "${RED}%10s${NORMAL} - Crap deletions not yet posted\n" $4
> 
> You want "not yet posted" in all cases.

OK thanks, I'll fix.

> "Crap deletions" may be offensive for Linux contributors whose code is
> being deleted.  Besides, if patches are not posted, somebody still spent
> time on making them.  Let's not discourage those who care.

Sure.

  Luis
