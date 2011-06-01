Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab1FABZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:25:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34954 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005Ab1FABZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:25:54 -0400
Date: Wed, 1 Jun 2011 11:25:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: clean up time (pass 1)
Message-Id: <20110601112547.02cf0904.sfr@canb.auug.org.au>
In-Reply-To: <20110601011215.GA16661@mtj.dyndns.org>
References: <20110601110616.861247de.sfr@canb.auug.org.au>
	<20110601011215.GA16661@mtj.dyndns.org>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jun_2011_11_25_47_+1000_x01V9ohcMteoKG_8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Jun_2011_11_25_47_+1000_x01V9ohcMteoKG_8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Wed, 1 Jun 2011 10:12:15 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Jun 01, 2011 at 11:06:16AM +1000, Stephen Rothwell wrote:
> > slabh
>=20
> This definitely is a dead branch.  It was a temporary testing branch
> preparing for wide-scale update and the whole thing has been in
> mainline for a very long time now.  Sorry about not updating it
> earlier.

Thanks, I will remove it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Jun_2011_11_25_47_+1000_x01V9ohcMteoKG_8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN5ZUbAAoJEDMEi1NhKgbsbFIH/2CaQkNHXaQsItDxqjOTLSEv
/lM0hdJv0ugOgXDpdx0dvcLAFD0dhI8vwvlgEvyczAXuqCTGnT4PGytyxcDTbr39
E0wyFm3qikHZWydniixmZ4klooj9SNLI2fPF+9gq/DKKEKkQI+2IoNQBXP67lzCM
anF6adpfkByrPf4MyDfr11lfPZaWUnNbtNdXPmcgK0+5UFR5LQSkKnZDJ/OZRAdn
5cFaS97rYr6bvQ7ivY1T/znVaUwktP/4lgQNthV+afPV3Dt+v+LtCDKz0El4JQR1
+VgpXiYfpvaed4UaTRygbMkIlbcgB438xKrZqDeu3lxHCW/HochzV15WqyXmQPE=
=Oy5N
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jun_2011_11_25_47_+1000_x01V9ohcMteoKG_8--
