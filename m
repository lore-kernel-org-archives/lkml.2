Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1DTEsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 00:48:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44781 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280Ab1DTEsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 00:48:38 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110420031105.GA11945@suse.de>
References: <20110419204117.979118654@clark.kroah.org>
	 <1303263653.3464.65.camel@localhost> <20110420020128.GA27631@suse.de>
	 <1303265862.3464.77.camel@localhost>  <20110420031105.GA11945@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-HKbxGgZiYdIkE0fAp07/"
Date: Wed, 20 Apr 2011 05:48:30 +0100
Message-ID: <1303274910.3464.95.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [12/28] x86, cpu: Clean up AMD erratum 400
 workaround
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HKbxGgZiYdIkE0fAp07/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-04-19 at 20:11 -0700, Greg KH wrote:
> On Wed, Apr 20, 2011 at 03:17:42AM +0100, Ben Hutchings wrote:
> > On Tue, 2011-04-19 at 19:01 -0700, Greg KH wrote:
> > > On Wed, Apr 20, 2011 at 02:40:53AM +0100, Ben Hutchings wrote:
> > > > On Tue, 2011-04-19 at 13:30 -0700, Greg KH wrote:
> > > > > 2.6.32-longterm review patch.  If anyone has any objections, plea=
se let us know.
> > > > >=20
> > > > > ------------------
> > > > >=20
> > > > > From: Hans Rosenfeld <hans.rosenfeld@amd.com>
> > > > >=20
> > > > > commit 9d8888c2a214aece2494a49e699a097c2ba9498b upstream.
> > > > >=20
> > > > > Remove check_c1e_idle() and use the new AMD errata checking frame=
work
> > > > > instead.
> > > >=20
> > > > Clean-up patches are generally not candidates for longterm updates.
> > >=20
> > > This was added because a follow-on patch required it.
> >=20
> > Ah yes, 'x86, AMD: Set ARAT feature on AMD processors' is using the sam=
e
> > condition.
> >=20
> > Of course, that could have been backported by referring to the function
> > that this removes, rather than pulling in a load of other changes with
> > consequent risk of regressions.
>=20
> I prefer to take original patches for stable, it makes it easier in the
> end.

It makes what easier, when?  What I see here is a bug fix that is much
larger than necessary, with a consequent risk of regression that seems
way out of proportion to the benefit.  (What actually *is* the benefit
of these AMD changes?)  And we have had several serious regressions in
the 2.6.32.y series recently, so I really don't think we are getting the
trade-off right.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-HKbxGgZiYdIkE0fAp07/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATa5lnee/yOyVhhEJAQr4xQ//Txa4B1/FNeEMaDNIVmaxCtHUdd/+2SKz
ZcGHJXuOrvZ9WUlydXdQKqyJiVaP1LtONTMA0SkHm+xBfbFDtp+ZbVQ9tcKWDGsu
GMcLCaxqVXWTtaK/KmickJ06WjVDlegXnzYNPpSMo89bW+jrW/A+SjgCfkez6OLG
I+LwZuY6ztAryJyJMX9L6hF6Taq02Moc9ztjrW0ltKlLp9ickt6qvzc+0RKrpqjb
KSywvD8FeCz+RATd+PCNvT0/OJPqD+BlITmIRvqeHYcgTeqTMhIfw4vk562yEpdU
rt7ZhS0AclsqBisAsqL7NIsmEf3uxw3ly3347XGUIpomiWz+sKtZ7il2fC7LT7xm
R1HoX9utPeTxeNAzfBbJriEaFimw+rbPZk63NATNnjkJCHLHO6uuL9+++BmwXjHs
9j9eaUfQJ8hxYYjeVeHAsjIIPqsJEf5Coz/4WHv3cHB+CQ4Rx78slV2iJGb2h1wt
XXkeO1q0srxeLOPZ2f8c2hab/Z1MDuYte0//Y4GN1nSRuAScV1be+CSoIlSeXyHl
fWMNKBgvS1h4f0A0RY6otzm3shmlI2enMFHE6F4z7KmNSbrCqJ/hJMVSZp0PaPdS
ax/9zPaWNF8i6JF+2X+ref4lNxFWTM8qHZvcAsCAgwVruMXY19fujMX62lxEItjV
BXWU4n//IBY=
=IubM
-----END PGP SIGNATURE-----

--=-HKbxGgZiYdIkE0fAp07/--
