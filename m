Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1IOBNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 21:13:13 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:37747 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab1IOBNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 21:13:10 -0400
Date: Thu, 15 Sep 2011 11:13:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: import of the kernel-doc tree failed
Message-Id: <20110915111301.a4227f9ca0d1f448d54050ae@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Sep_2011_11_13_01_+1000_rew9D0BZSEhKjfy="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Sep_2011_11_13_01_+1000_rew9D0BZSEhKjfy=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

Importing the kernel-doc tree today produced this error:

$ git am ../quilt/kernel-doc/docum-leds-class-fix-typo.patch
Patch format detection failed.

I just had to replace the tab in the From: line with a space.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Sep_2011_11_13_01_+1000_rew9D0BZSEhKjfy=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcVEdAAoJEDMEi1NhKgbshwgH/3bjUKc/MBHxDxe+eZm5onga
aiLlnSD5KYidpGK+AQqQO8IUqwVjmd8J/d0wjI6pzD/b3TpDV7BddxCcerEdvr4B
TOx2ANj44vVsaWHlRd0oPT3diLTUdlPg76kGQ/Yto/UVLk65q715dJY28PqjFMSX
NQV8RVhKcxE3Qo261kO0hYbJuAn/CydQ3Vs5S2f+1SkedDuVisy5BCzineiecrFE
3gBxdQW7XJdg8OiAMXbvj1Z9twWm0Uuu+oqhTICbZl7/SLZFOg/XWCZ1GNLjn3KT
myIGgTF8M3EdHTgOBfUv8L0dDnLUJsiSISyMksWUJrtX91wDivRcTPfBiJ0puWI=
=SjzB
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Sep_2011_11_13_01_+1000_rew9D0BZSEhKjfy=--
