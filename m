Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1GOOaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:30:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32868 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314Ab1GOOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:30:05 -0400
Subject: megaraid vs i2o for PCI device ID 101e:1960
From: Ben Hutchings <ben@decadent.org.uk>
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: 632187@bugs.debian.org, operator@ins.uni-bonn.de,
        Vasily Averin <vvs@sw.ru>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4E1EB3E8.1090503@ins.uni-bonn.de>
References: <4E0C5B57.2020104@ins.uni-bonn.de>
	 <handler.632187.B.130943320529363.ack@bugs.debian.org>
	 <4E0D8BAE.1000004@ins.uni-bonn.de> <1310531358.8783.249.camel@localhost>
	 <4E1E989A.2090307@ins.uni-bonn.de>  <4E1EB3E8.1090503@ins.uni-bonn.de>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-MrrhC4TuTahaRyxn5r5l"
Date: Fri, 15 Jul 2011 15:29:56 +0100
Message-ID: <1310740196.8783.288.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MrrhC4TuTahaRyxn5r5l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-07-14 at 11:16 +0200, Alexander Schier wrote:
> On 07/14/2011 09:19 AM, Alexander Schier wrote:
> > Hi!
> >
> > On 07/13/2011 06:29 AM, Ben Hutchings wrote:
> >> Can you try adding 'blacklist=3Di2o_core' to the kernel parameters, so
> >> only the megaraid driver is used?
> > We will try this.
> Now it works, when i2o_core is blacklisted.

Alexander reported in <http://bugs.debian.org/632187> that the kernel
took a very long time to boot, and the log showed first i2o_core and
then megaraid failing to probe a device (ID 101e:1960).  But above he
reports that megaraid is able to probe it successfully if i2o_core
didn't break it first.

Should this device be blacklisted from i2o_core?  Are there likely other
MegaRAID devices that use the I2O PCI class but don't work with this
generic driver?

Ben.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer

--=-MrrhC4TuTahaRyxn5r5l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATiBO3ee/yOyVhhEJAQqc/Q/+O4y0d1FLVpzF1DttJZloUmC5QbUiEY5M
ZMrkleQriZfa0n6WuKAfvWO67Uqxf4LqcPYH6R/sb6to162Vbx39/oYaAxv5ZY+c
Cz37x0UIHxZ5983XLKFhLwKRaSnJs7v7+8IkitrT9DA6S027Eq56BMbqXyKaxRyD
QdXxbAUvmDhNpqr5prrxA5ePF7nIUJsW7zz6T2KITcWEU2lDxxuGvL1P+tr6c+/y
sosHfW5AlMvJmsCwx7LobP0+w2hLeqeoKeSj2+TOqZCHRCxgPv9AYL314kCcmPCu
OdmChstR5hDJ/i5XLQV6EioH5MrngSobOF6+Of77L6vwh/A7xRB+LiQoWnLa/ozi
p6zwYsjeeJZ8bo/k879jEEcKCpJR+lRLyhz3VjVb/MUidC7/M9JHPsnjeRfivE+C
RUIr+ORnSU40XIkyZ8wRsrnO8UXmS3whmfH6FBHt1bXLHRTdmFc/tWxn2QzMxBrf
ZkS3up2awZSNryhoG1PZDVZthmQhS4fTBfXOf6ERTu8OMoKKweT6UXnOC1K3e7v2
JCWO306StYbUVt2MGGiEa5qr/s+y+ACH3QGa+9UvcCfVXWucm4O0Zv1V78xW8j7r
yxx+Y8LXnWi9U+4G3dwWPiNODWDznYZy1eI1VKQQWmjnRdKE2RGilFDELYxnlIUH
MoihPhecUtM=
=Cz/5
-----END PGP SIGNATURE-----

--=-MrrhC4TuTahaRyxn5r5l--
