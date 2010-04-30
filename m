Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab0D3RR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:17:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44736 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932993Ab0D3RRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:17:40 -0400
Date: Fri, 30 Apr 2010 10:01:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: linux-next: build warning after merge of the
 driver-core.current tree
Message-Id: <20100430100102.0f08c9ad.sfr@canb.auug.org.au>
In-Reply-To: <20100429234525.GB16141@kroah.com>
References: <20100430093534.9fc6ab8f.sfr@canb.auug.org.au>
	<20100429234347.GA16141@kroah.com>
	<20100429234525.GB16141@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Apr_2010_10_01_02_+1000_oc5yBUf2UNTuEjN_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Apr_2010_10_01_02_+1000_oc5yBUf2UNTuEjN_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 29 Apr 2010 16:45:25 -0700 Greg KH <greg@kroah.com> wrote:
>
> > Thanks, I've fixed this up, the release call should not have 'const'
> > on it as it is going to touch the pointer passed to it :)
>=20
> And it's now pushed out in my tree.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Apr_2010_10_01_02_+1000_oc5yBUf2UNTuEjN_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvaHb4ACgkQjjKRsyhoI8xtOgCgvh2evjACoaxxT+9gtQb9bsdM
PPAAnizzkQvx35ogbIp9YUIR9lwvfrmL
=o2Ye
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Apr_2010_10_01_02_+1000_oc5yBUf2UNTuEjN_--
