Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2GRS22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 14:28:28 -0400
Received: from ngcobalt07.manitu.net ([217.11.48.107]:39450 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2GRS20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:28:26 -0400
X-Greylist: delayed 1771 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2012 14:28:26 EDT
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Wed, 18 Jul 2012 19:58:47 +0200
From: Roland Eggner <edvx1@systemanalysen.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: formail doing weird things (was: [ 01/37] Remove easily
 user-triggerable BUG from generic_setlease)
Message-ID: <20120718175847.GA5666@mobil.systemanalysen.net>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
 <20120718001414.GA17973@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20120718001414.GA17973@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-07-17 Tuesday at 17:14 -0700 Greg KH wrote:
> On Tue, Jul 17, 2012 at 05:02:38PM -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> >=20
> > 3.4-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
>=20
> Argh, I give up, I just can't get message threading working properly
> these days.  These are the 3.4 patches, in response to the 3.0 patches,
> and it took 2 tries to send them out due to formail doing wierd things.

A few months ago I could fix my =E2=80=9Cformail troubles=E2=80=9D by remov=
ing option =E2=80=9C-d=E2=80=9D from=20
formail calls in my scripts.  formail manpage conceals nasty consequences o=
f =E2=80=9Cdo=20
not require strict mbox format=E2=80=9D:  nearly any =E2=80=9Cfrom=E2=80=9D=
 nearby an empty line and=20
probably other things will trigger message splitting.

Maybe this helps you or somebody else.

Sorry for being slightly OT, and many thanks for your great maintainance wo=
rk on=20
stable kernel releases.

--=20
Roland Eggner

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAlAG+VcACgkQdN/hKfT7G/LQBwCggYjoaW574LAl5OQWW5HMN14b
kPAAn1Irrr1iNn+NyzDM47uMByrkaXyx
=8da2
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
