Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab1ITGrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 02:47:00 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58164 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1ITGq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 02:46:58 -0400
Date: Tue, 20 Sep 2011 16:46:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20110920164649.b22e95cf65f4678da99a0a81@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__20_Sep_2011_16_46_49_+1000_AA=219hnXcLXvndo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Sep_2011_16_46_49_+1000_AA=219hnXcLXvndo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/comedi/drivers/ni_labpc.c between commit c19cc78efe92
("staging: fix comedi build when ISA_DMA_API is enabled but COMEDI_PCI is
not enabled") from Linus' tree and commit d6aa8366dde1 ("staging: fix
comedi build errors") from the staging tree.

I have used the version from Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Sep_2011_16_46_49_+1000_AA=219hnXcLXvndo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOeDbZAAoJEDMEi1NhKgbsT/UIAICZIXe5DABxlRKizz7ep0Ja
A/DU2LVgDAPYuJBves/DqJj9C14zCP719WXDu2N+ZR/9DPwwwZfr5sXPxjGKvUtT
7a71IqOVC/OEWBqZ0IOuZKUPzutKtzFK3HLcUAbb5cpComxZ6XiSlMGSC5aVcEba
bacX+UgrqhNiYF4Dw8VW3APGXxYCHEmJoWdhP/2E8hvM5nr4F+goU5Z3pGC+5O7S
kDgeGHB8qX+sz/8H4EDsiwtgGT34nriWlwq2dBm1EjG+C1kO0rmBqgLmhV/fWvCI
xyqXkVEMa3WhuQfps/buZxZZtgTvxVjYjMBPClyooIBmmDwTPtvtrGhSUIKhd/M=
=QYt8
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Sep_2011_16_46_49_+1000_AA=219hnXcLXvndo--
