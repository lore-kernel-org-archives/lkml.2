Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab0HEDFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:05:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50441 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958Ab0HEDFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:05:06 -0400
Date: Thu, 5 Aug 2010 13:04:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>,
        linux-cifs@vger.kernel.org
Subject: Re: linux-next: manual merge of the workqueues tree with the Linus'
 tree
Message-Id: <20100805130459.f62468cd.sfr@canb.auug.org.au>
In-Reply-To: <20100723214233.7cb7de8d.sfr@canb.auug.org.au>
References: <20100723144600.dd4da992.sfr@canb.auug.org.au>
	<4C497CD5.5010908@kernel.org>
	<20100723213148.3d2193a3.sfr@canb.auug.org.au>
	<4C497E5F.80301@kernel.org>
	<20100723214233.7cb7de8d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_Aug_2010_13_04_59_+1000_MI9q3On79epXvy56"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Aug_2010_13_04_59_+1000_MI9q3On79epXvy56
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Fri, 23 Jul 2010 21:42:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Fri, 23 Jul 2010 13:34:55 +0200 Tejun Heo <tj@kernel.org> wrote:
> >
> > I was thinking about sending pull request w/ a note describing how to
> > resolve the conflict.  Would pulling in master before requesting pull
> > be better?
>=20
> Either would work.  Linus is fine with doing merge fixups and, after all,
> I figured it out. :-)
>=20
> A description always helps, of course.

Linus has merged the cifs tree, so you could fix these conflicts in your
tree by merging the cifs tree that Linus' merged (rather than merging
against all of Linus' tree).   That would be commit
cb76d5e25008b76fb8e348c861d32659430ac3fa ("cifs: fsc should not default
to "on"") in Linus' tree.

Or you could leave it all to Linus if you want to.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Aug_2010_13_04_59_+1000_MI9q3On79epXvy56
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMWipbAAoJEDMEi1NhKgbsIXwIAKDIhgsSkw+dLH5zuFDoUcuq
DbcgI0RXEmnR2Nd8PcH/XKGdYcevGmrbT/n6TwU0glPDNHYDEirNRn5BLLy4wCx8
aC23nEA15TrqqwlwO4wQ45n7t+EKJgLNnxlggbhDU0x2CMusWK9+xhplNDcsTKm+
4366RF7zhvAPc/z7r1hcSMhe2ZAvp1XnnxyKu+HKRG7SdFh2AvM0dwotYb0A0M0R
OHeOTnUZi/K2wTpiFxVrHSSBwyDJHPili4bRKx7P093cp8CWICR5xOtxALI52ixB
gRESUdXpSX8wR+U/INQzR/goOYsDK9g7WXtz/eRDFD0rZGFmtuSSEt0dpQBmR6U=
=IgVT
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Aug_2010_13_04_59_+1000_MI9q3On79epXvy56--
