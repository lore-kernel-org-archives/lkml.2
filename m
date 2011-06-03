Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab1FCLiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:38:55 -0400
Received: from frost.carfax.org.uk ([212.13.194.111]:33716 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1FCLix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:38:53 -0400
Date: Fri, 3 Jun 2011 12:38:42 +0100
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: Mitch Harder <mitch.harder@sabayonlinux.org>, dave@jikos.cz,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kreijack@libero.it
Subject: Re: linux-next: build warninga in Linus' tree
Message-ID: <20110603113842.GA10842@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Mitch Harder <mitch.harder@sabayonlinux.org>, dave@jikos.cz,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kreijack@libero.it
References: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
 <20110531175709.GC12709@twin.jikos.cz>
 <BANLkTi=t5H8sAc_0sHyFt_xJgbeVibO3KQ@mail.gmail.com>
 <20110603111048.GR12709@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <20110603111048.GR12709@twin.jikos.cz>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.20 (2009-06-14)
X-frost.carfax.org.uk-Spam-Score: -0.0 (/)
X-frost.carfax.org.uk-Spam-Report: Spam detection software, running on the system "spamd3.lon.bitfolk.com", has
 identified this incoming email as possible spam.  The original message
 has been attached to this so you can view it (if it isn't spam) or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On Fri, Jun 03, 2011 at 01:10:49PM +0200, David Sterba wrote:
    > On Wed, Jun 01, 2011 at 10:16:48AM -0500, Mitch Harder wrote: > > I've
   been playing around with resurrecting the basic sysfs > > capabilities that
    had been previously incorporated into btrfs. > > > > As it stands right now,
    it was relatively easy to re-implement sysfs > > as it was originally. However,
    that implementation of sysfs wasn't > > populated with much information (only
    total_blocks, blocks_used, and > > blocksize). > > Goffredo Baroncelli (CCed)
    posted a patch to enhance sysfs interface: > > https://patchwork.kernel.org/patch/308902/
    > (http://www.spinics.net/lists/linux-btrfs/msg06777.html) > > > I also had
    to reverse a small portion of code that was in the last > > clean-up. > >
    Restoring the code should not be a problem, the cleanup was too eager > and
    I think a sysfs inteface would be good, not only for debugging > purposes
    or tuning. [...] 
 Content analysis details:   (-0.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.0 T_RP_MATCHES_RCVD      Envelope sender domain matches handover relay
                             domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 03, 2011 at 01:10:49PM +0200, David Sterba wrote:
> On Wed, Jun 01, 2011 at 10:16:48AM -0500, Mitch Harder wrote:
> > I've been playing around with resurrecting the basic sysfs
> > capabilities that had been previously incorporated into btrfs.
> > 
> > As it stands right now, it was relatively easy to re-implement sysfs
> > as it was originally.  However, that implementation of sysfs wasn't
> > populated with much information (only total_blocks, blocks_used, and
> > blocksize).
> 
> Goffredo Baroncelli (CCed) posted a patch to enhance sysfs interface:
> 
> https://patchwork.kernel.org/patch/308902/
> (http://www.spinics.net/lists/linux-btrfs/msg06777.html)
> 
> > I also had to reverse a small portion of code that was in the last
> > clean-up.
> 
> Restoring the code should not be a problem, the cleanup was too eager
> and I think a sysfs inteface would be good, not only for debugging
> purposes or tuning.

   Indeed. There's a few parts of the balance API that would be
significantly enhanced by being able to put things in sysfs. I could
drop at least one (if not two) of the three ioctls if I had somewhere
in sysfs to put the relevant files.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- The glass is neither half-full nor half-empty; it is twice as ---  
                        large as it needs to be.                         

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN6MfCIKyzvlFcI40RAnWZAJ9JEk+rsOrWQaDG2hvcERAlCnbwXwCfcscI
VaTkW2Oo9iLEvkUwgQ13764=
=GafF
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
