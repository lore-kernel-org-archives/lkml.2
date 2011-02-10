Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab1BJF3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 00:29:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56960 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1BJF3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 00:29:20 -0500
Date: Thu, 10 Feb 2011 16:29:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>, Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the tty tree with the m68knommu tree
Message-Id: <20110210162914.eec2f4b5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Feb_2011_16_29_14_+1100_gjoGMJuoLfyT.1W7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Feb_2011_16_29_14_+1100_gjoGMJuoLfyT.1W7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/68328serial.c between commit
abf67e214f867d16df6a9c4ac7d8fc0b98ebad97 ("m68knommu: fix derefernce of
port.tty") from the m68knommu tree and commit
f094298bae5f5d0e1cb3bff4621aae7ef486812a ("68328serial: remove unsed
m68k_serial->tqueue_hangup") from the tty tree.

I just used the latter since it removed some of the code modified by the
former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Feb_2011_16_29_14_+1100_gjoGMJuoLfyT.1W7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNU3eqAAoJEDMEi1NhKgbs/PsH/0rwIhl+ojA/NxrQDo/TaIgY
lB1tkTAl7yIhKGDArDl1/9QIREuSw4ueR4U6byyCcYDA40rP08MoNonTHNzkVOrX
K0nn9jedTmakJNfW5aGptte7H0lh5qoCsHD6HqJXTZ1Ux/wEfJDS1stKa47zps6m
U2WSj+dycgD/Ir2OXZmdRJtYXnbdEEqramZNYcvg4/UG10fy1ZM3ZwEery0ETIBu
zK9ff6VT7R8XWboLPofmjmhY6ddodc+EtTnvpW8u/GLzbehlGjZ2xCID70hGt284
RIL14jUKzXL0HwhgeoJGgDRjycYXHFcHJcv82DBAVco9U06GB4JcGzTO2JCrm1Q=
=3+Oa
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Feb_2011_16_29_14_+1100_gjoGMJuoLfyT.1W7--
