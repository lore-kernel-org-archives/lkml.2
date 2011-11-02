Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab1KBBWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 21:22:25 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47365 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab1KBBWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 21:22:23 -0400
Date: Wed, 2 Nov 2011 12:22:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: linux-next: manual merge of the bjdooks-i2c tree with Linus' tree
Message-Id: <20111102122221.9040e7a07bb0e3e2c46a5188@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Nov_2011_12_22_21_+1100_yvRo.GCh3.I1.JQA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Nov_2011_12_22_21_+1100_yvRo.GCh3.I1.JQA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

Today's linux-next merge of the bjdooks-i2c tree got a conflict in
drivers/i2c/busses/i2c-designware-platdrv.c between commit 4311051c358a
("i2c: irq: Remove IRQF_DISABLED") from Linus' tree and commit
f8420b7bf6ce ("fixup merge") from the bjdooks-i2c tree.

I fixed it up (by removing the IRQF_DISABLED flag) but this change should
probably be sent to Linus as it appears to have been fixed up incorrectly
there.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Nov_2011_12_22_21_+1100_yvRo.GCh3.I1.JQA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsJtNAAoJEECxmPOUX5FEdPkP/jTKHcgBybapWt3Y3GOA4HyL
SCbKUULAQhMyed59Sf+ywMjkdZ8XZtORafG5Di6BPQtu3xGSeEsLA6b7n0JE6gju
gUtoMJVJ4j8jD09psfsEzAlW+iR9hfK2V2I3aJV4jeXsRkAVjl4gG9Bb0KOlwSv1
/7Gi38xJR4flJ8uMDo060t2FbzgrArf2CvS6IKh5CL/KRMhJOiumDaBoc5S3dMSY
/x09QWa7BzpBvj9n6QgnAWTQO5W9Rbozua3Qw3XGLoDeG/iQ3zyZwbOBLfbg6nJ2
z7Vcb/mnQhy82LS8iJ4mUbkdYHuy9shZe9Ni0fpWK2AMwOLQe4KKekoWLATngJtq
qEFBkL1zNT8XgRbUw3KJclRW7v90OGWo5qIWVzBS7aVjWjnorxKEqRNqzBuaQMkQ
J3wEcH8zrh8Vz6bNefP8ThAqY72+55VmZeM5JV0IT+37FocXxh9HeIZNgX/2Vq0a
C7m4APeBTizqwQSErImg7FnMHXhDb9HE/OsnAlnLmGiue3o2c+7VATAwhOysaz+O
n+jIvY1gcXFueUMyaNsmnTK9i6fhJN29RmmF23wTBcFZZZx4izsCqJf/2xm3P1JG
b/9cSGwfaG70a6xT4BgZspl++r5eWAiTeuQjFtmzRisWAcMluERL7v0UtlyjUVpd
3WfT4HjwmLqhfoL5ZP0g
=Ieio
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Nov_2011_12_22_21_+1100_yvRo.GCh3.I1.JQA--
