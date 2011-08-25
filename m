Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab1HYEMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 00:12:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47671 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab1HYEMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 00:12:21 -0400
Date: Thu, 25 Aug 2011 14:12:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: linux-next: build failure after merge of the ptrace tree
Message-Id: <20110825141212.4f82835beaad506553e291e8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Aug_2011_14_12_12_+1000_yx2XhPLFQtT1siBY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Aug_2011_14_12_12_+1000_yx2XhPLFQtT1siBY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the ptrace tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: ".set_current_blocked" [fs/autofs4/autofs4.ko] undefined!

Presumably set_current_blocked() needs to be EXPORTed.

I have used the ptrace tree from next-20110824 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__25_Aug_2011_14_12_12_+1000_yx2XhPLFQtT1siBY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVcucAAoJEDMEi1NhKgbsXj4IAIbVVS9tFmuWZMaB0SmSbn4b
5nqqC430w26pvidQ6Ejjcd7BO0ScTIQt0GyMIPhxmjUf1ppkvnqoqD9YN83Kz9Po
C8R5A2kiIT6ZXbz1tz8Bl3rGGPwJnbcnUyvAJZeS0QsOuMqKqUbnnFP8bCntqAgE
pw2lXH38+tVPX+7dF0Pu/6LUYeLCK9D4mcb7IslOs+0gAUYn6X5L21bNFL3AXlND
LcIQ9hyGW6g6sYzY1qx0zDlfpojzpBKqeuNr3GhMxoL2j1pQ3omUNDzLe5leUlTn
cOrlIyjIvreVLdcsW8YeQxlQuL7GvksT8p+TMqQt8UWW5R6L/KcI+3xfEPSF1sw=
=BZiE
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Aug_2011_14_12_12_+1000_yx2XhPLFQtT1siBY--
