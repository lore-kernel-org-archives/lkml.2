Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2F2Crv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 22:47:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56955 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2F2Crt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 22:47:49 -0400
Date: Fri, 29 Jun 2012 12:47:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the hid tree
Message-Id: <20120629124731.4577c98083269ca2d20c8d5f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Jun_2012_12_47_31_+1000_PDICZniwoS56VR9e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jun_2012_12_47_31_+1000_PDICZniwoS56VR9e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

After merging the hid tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/hid/Kconfig:698: unexpected 'endif' within menu block
drivers/hid/Kconfig:702: unexpected 'endmenu' within if block
drivers/Kconfig:151: 'endmenu' in different file than 'menu'
drivers/hid/Kconfig:79: location of the 'menu'
arch/powerpc/kvm/Kconfig:153: syntax error
drivers/Kconfig:1: missing end statement for this entry

Caused by bad merge 8494746044bf ("Merge branch 'roccat' into
for-next").  This added a second copy of

menu "Special HID drivers"

I have used the hid tree from next-20120628 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__29_Jun_2012_12_47_31_+1000_PDICZniwoS56VR9e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP7RdDAAoJEECxmPOUX5FEzKcQAJfv6OoYw+pCdPlcf5p19ALo
em4h7Etgt14dQiSjP3H/BilPbrOuMyVZzFzBd6Wx1+SI0GVyn+j/IwkKsOtfdraT
xfyydiD6FDAzi/80SXkr8jPOy7cUb1v/Ei+MfFtiJJh22aS1lGaWBo51ebcMyXXE
dpa57vjBtSO7ZfVvMdOWckDW8nS7J8bqZZVmzGkBdfybreWzI6g07EpYeu5lAKr0
//8Sq2rMJSzZroKSCEYqeZ2AVLaXS+Lz634nIE95yKlbDrYHmTvw9Sceu3B25hR9
y2t0KprZTUHN1aKK7PYDjMc40cqA+02VMsy/2p+p2D4ZpsjqizOyli8NJt+F9GvP
JnXYuZJt0N28ZI6k2Uwaan5TygE+c318m+fC65gaavmTzplesEQxxbySPC9+DZrP
0W4Pb9mJy31CyN6owrjhqAFNq7m3TZKzOy7Jj0M0DrYuf0MJaojmlbB/EyuuxWSK
1eq3kh+vwz1RZmDP8yXj7nmiEHVsWEYJkaw8v/O/trmO+H26nr6Ejobr35l/HbRO
kU6KnvHBuQ8CfqgowkrreB/3Rkvy4jyEnohk3ve0WrNBtHDq2hFXtIN78FuC0OQ2
y52mT+hZhhqWy5HNa/ByuYbpdk4BAmbwJDLATSuZBJtv4ytl3wkCfbU1/IzQZ2x8
Aj5QQoZEz8avlRJ9XIAZ
=P57k
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jun_2012_12_47_31_+1000_PDICZniwoS56VR9e--
