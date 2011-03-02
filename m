Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab1CBF6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:58:03 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51993 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab1CBF6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:58:00 -0500
Date: Wed, 2 Mar 2011 16:57:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anand Gadiyar <gadiyar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        Keshava Munegowda <keshava_mgowda@ti.com>
Subject: linux-next: manual merge of the usb tree with the omap tree
Message-Id: <20110302165755.b45124c8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Mar_2011_16_57_55_+1100_CzyKTeIU9uK3tpna"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Mar_2011_16_57_55_+1100_CzyKTeIU9uK3tpna
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-omap2/board-4430sdp.c between commit
1dbea0f5e23b6c647db72fa4a048cb7140625e13 ("arm: omap4: 4430sdp: drop ehci
support") from the omap tree and commit
181b250cf53233a7a7c6d7e1e9df402506712e93 ("arm: omap: usb: create common
enums and structures for ehci and ohci") from the usb tree.

The former removed the code modified by the latter, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Mar_2011_16_57_55_+1100_CzyKTeIU9uK3tpna
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNbdxkAAoJEDMEi1NhKgbs7qQH/ixKes0qi1MAw0NKFEK0AOZb
BvPWfv5f+b4929JeklVxlnTTzc8PAXd6qKkUNT+9N0S7yWuYHoKlFKIeeB4rlGin
lzeDuzw6BEWgES0UynrfwBg7R0L0xnAIaF/dkfuPZCD9efN2acKy/M9MJH/Bd/1C
KAg0mA2Q0ngVtQOVShHZSCKvWQhzAqhytSsVuqPCE91/7QjfzEtxKvI/1s5YhD0g
dszk4eS+UHRj7h6Nx7X6xd/RIeAvq0q4ZQl/vMVJP11cXvivTPSd7DfgwWTUdGuX
/NbndtDctBaANeOSCHyYeaBk5i9xns6pPL7eLUxJloCsJczAa1C56rwRX3RXg1Y=
=dfVb
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Mar_2011_16_57_55_+1100_CzyKTeIU9uK3tpna--
