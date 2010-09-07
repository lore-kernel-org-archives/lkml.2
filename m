Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0IGByh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:54:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44049 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab0IGByc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:54:32 -0400
Date: Tue, 7 Sep 2010 11:54:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, Jason Baron <jbaron@redhat.com>
Subject: linux-next: build warning after merge of the final tree
 (driver-core tree related)
Message-Id: <20100907115426.fc0c3e13.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Sep_2010_11_54_26_+1000_oW_.7F2aOuokK27j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Sep_2010_11_54_26_+1000_oW_.7F2aOuokK27j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) produced this warning:

kernel/params.c: In function 'parse_args':
kernel/params.c:233: warning: the frame size of 1032 bytes is larger than 1=
024 bytes

Introduced by commit 32e6407e9361cd1aac39ff6b744cad48d1802a08 ("Dynamic
Debug: Introduce global fake module param module.ddebug") which added a
1024 byte array to the stack ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Sep_2010_11_54_26_+1000_oW_.7F2aOuokK27j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMhZtSAAoJEDMEi1NhKgbshgsH/i5yEBe4TUeT3uFYFNwJd2vz
pUsLsmMxPHxLCZ6hnTjQeoQtR4v3SCDmxaqFtWkHvQxBu6rh6xI0yMvVn0KbIix3
ehKxLunpnNieZKGjfkAlBHlFlkTaVqMe730NwIUCf0csBIDRyX0JgF9VbbJjwFNs
UfYDgivL8AtQfPLKst29MPu22P29cegF0mmM/duDIcGUF1A9DWo0CCqcqcCbwqON
Psog3lU9Rd/7cr+8uXy+iMfpI/ABKrve+y29rzCvoO6x1h9LtlajtXRUXlhG/qEi
EZw3kpX5CMXMfC1uN6yjgxbD1wkDWqmlvpddloAy1/vSGRFVxxt7hWCS/eFezWk=
=2XCE
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Sep_2010_11_54_26_+1000_oW_.7F2aOuokK27j--
