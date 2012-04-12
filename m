Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762630Ab2DLUIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:08:10 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54531 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965957Ab2DLUIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:08:04 -0400
Date: Thu, 12 Apr 2012 13:07:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Adrian Chadd <adrian@freebsd.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120412200759.GB23764@kroah.com>
References: <20120411231102.GA6404@kroah.com>
 <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
 <20120412002927.GA23167@kroah.com>
 <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
 <20120412011313.GA23764@kroah.com>
 <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
 <20120412144626.GA14868@kroah.com>
 <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
 <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
 <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 09:43:33PM +0300, Felipe Contreras wrote:
> On Thu, Apr 12, 2012 at 8:24 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> > On 12 April 2012 09:49, Felipe Contreras <felipe.contreras@gmail.com> wrote:
> >
> >>>
> >>> A revert is the same as a patch.  It needs to be in Linus's tree before
> >>> I can add it to the stable releases.
> >>
> >> Right, because otherwise people's systems would actually work.
> >>
> >> But hey, as I said, following rules is more important, regardless of
> >> what the rules are, and why they are there. The rules that actually
> >> triggered this issue in v3.3.1, as this is not in v3.3.
> >>
> >> You could just accept that the patch should have never landed in
> >> v3.3.1 in the first place, but it's much easier to arbitrarily keep
> >> stacking patches without thinking too much about them.
> >
> > Greg is doing the right thing here. We face the same deal in FreeBSD -
> > people want fixes to go into a release branch first, but if you do
> > that you break the development flow - which is "stuff goes into -HEAD
> > and is then backported to the release branches."
> >
> > If you don't do this, you risk having people do (more, all)
> > development and testing on a release branch and never test -HEAD (or
> > "upstream linux" here). Once you open that particular flood gate, it's
> > hard to close.
> 
> But this is exactly the opposite; the patch that broke things is in
> the 'release branch' (3.3.1); it's not in upstream (3.3). Sure, it's
> also on a later upstream, which is also broken.

What is the git commit id of the patch in 3.3.1 that caused this to
break?  This is the first time I have heard that 3.3 worked and 3.3.1
did not work.  Someone needs to tell me these things...

greg k-h
