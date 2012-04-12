Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934706Ab2DLU71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:59:27 -0400
Received: from blackhole.sdinet.de ([176.9.52.58]:50098 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab2DLU7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:59:25 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2012 16:59:25 EDT
Date: Thu, 12 Apr 2012 22:52:08 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Greg KH <gregkh@linuxfoundation.org>
cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Adrian Chadd <adrian@freebsd.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
In-Reply-To: <20120412200759.GB23764@kroah.com>
Message-ID: <alpine.DEB.2.02.1204122243080.1835@aurora.sdinet.de>
References: <20120411231102.GA6404@kroah.com> <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com> <20120412002927.GA23167@kroah.com> <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com> <20120412011313.GA23764@kroah.com>
 <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com> <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com> <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
 <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com> <20120412200759.GB23764@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1516993383-1334263935=:1835"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1516993383-1334263935=:1835
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 12 Apr 2012, Greg KH wrote:

> On Thu, Apr 12, 2012 at 09:43:33PM +0300, Felipe Contreras wrote:
> > On Thu, Apr 12, 2012 at 8:24 PM, Adrian Chadd <adrian@freebsd.org> wrot=
e:
> > > On 12 April 2012 09:49, Felipe Contreras <felipe.contreras@gmail.com>=
 wrote:
> > >
> > >>>
> > >>> A revert is the same as a patch. =A0It needs to be in Linus's tree =
before
> > >>> I can add it to the stable releases.
> > >>
> > >> Right, because otherwise people's systems would actually work.
> > >>
> > >> But hey, as I said, following rules is more important, regardless of
> > >> what the rules are, and why they are there. The rules that actually
> > >> triggered this issue in v3.3.1, as this is not in v3.3.
> > >>
> > >> You could just accept that the patch should have never landed in
> > >> v3.3.1 in the first place, but it's much easier to arbitrarily keep
> > >> stacking patches without thinking too much about them.
> > >
> > > Greg is doing the right thing here. We face the same deal in FreeBSD =
-
> > > people want fixes to go into a release branch first, but if you do
> > > that you break the development flow - which is "stuff goes into -HEAD
> > > and is then backported to the release branches."
> > >
> > > If you don't do this, you risk having people do (more, all)
> > > development and testing on a release branch and never test -HEAD (or
> > > "upstream linux" here). Once you open that particular flood gate, it'=
s
> > > hard to close.
> >=20
> > But this is exactly the opposite; the patch that broke things is in
> > the 'release branch' (3.3.1); it's not in upstream (3.3). Sure, it's
> > also on a later upstream, which is also broken.
>=20
> What is the git commit id of the patch in 3.3.1 that caused this to
> break?  This is the first time I have heard that 3.3 worked and 3.3.1
> did not work.  Someone needs to tell me these things...

Should be

db6a6a78d8602964c9dfb1d8ce18daefd92da0a7 in stable/linux-3.3.y
c1afdaff90538ef085b756454f12b29575411214 in linux/master

c'ya
sven-haegar

--=20
Three may keep a secret, if two of them are dead.
- Ben F.
--8323328-1516993383-1334263935=:1835--
