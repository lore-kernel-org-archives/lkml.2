Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab1CHQKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:10:44 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:56454 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab1CHQKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:10:43 -0500
Date: Tue, 8 Mar 2011 17:10:38 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG and freeze on cat /proc/tty/driver/serial
Message-ID: <20110308161037.GA19950@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	linux-kernel@vger.kernel.org
References: <20110216161728.GA8431@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20110216161728.GA8431@darkside.kls.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, Feb 16, 2011 at 05:17:28PM +0100, Mario 'BitKoenig' Holbe wrote:
> reading /proc/tty/driver/serial leads to a NULL pointer dereference BUG
> and freeze on a serial-console enabled 2.6.35.{4,10,11} and 2.6.37.
> 2.6.32.28 does fine without BUG and freeze.

This issue persists with 2.6.37.3 and 2.6.38-rc8.


regards
   Mario
--=20
Good, Fast, Cheap: Pick any two (you can't have all three).
                                            -- RFC 1925, 7a

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTXZU/RS+e2HeSPbpAQJZGQgAoD8SmFCzQ85GN46dCStORxmecliBs93y
ME6qN2OHuHfC5cGAjDLCG7QUzEMtWMOgIkVdMgVqJLveQ8ffrpYfNNxuROy+iW2B
wLZj9PbKABS1Fn1ml8PGeR7CTquhgjTQqOtSHpRbIPoTlwikaVg8FWy4knbQghkZ
48NV6J9ltPQ7o9PKzhWIz4YoFykd35Pj9otsWG9gBQMGsS0/G3ULCuk6TZVE9r3i
1AUNJAAoXhDPixDBOwCQJBCu1jmqdbc8VtWke/rdjSflFbcVG4Hj1xIUZRL9Se8K
6nyH4QwcZC6N/5m+XCeCuTpnW/1wbuSQiUF81tDJL0Ejfaf4QNT2oQ==
=iRPl
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
