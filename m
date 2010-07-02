Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0GBFij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 01:38:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34027 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab0GBFih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 01:38:37 -0400
Date: Fri, 2 Jul 2010 15:38:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Glendinning <steve.glendinning@smsc.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: linux-next: manual merge of the driver-core tree with the
 jdelvare-hwmon tree
Message-Id: <20100702153827.cecff5e6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__2_Jul_2010_15_38_27_+1000_m3wvQ4zH7PA4OTwj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_Jul_2010_15_38_27_+1000_m3wvQ4zH7PA4OTwj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
MAINTAINERS drivers/hwmon/emc2103.c between commit
7c73bc52c98623e7ae2831ec8df80e882aa4087f ("hwmon: Add driver for SMSC
EMC2103 temperature monitor and fan controller") from the jdelvare-hwmon
tree and commit 3b52586d66843792f6556b3dd33205375d9b4196 ("hwmon: Add
driver for SMSC EMC2103 temperature monitor and fan controller") from the
driver-core tree.

Looks like two versions of the same patch.  I used the newer one (from
the jdelvare-hwmon tree).  I guess this should be dropped from one of the
two trees.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__2_Jul_2010_15_38_27_+1000_m3wvQ4zH7PA4OTwj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMLXtTAAoJEDMEi1NhKgbsrnsH/A8x0ZLP6vWsH8GRFBMDxj3O
fhkaPj2Am0hNaFKkDq0re7ORZ/AgBWK55gzoGPMnYlwwJSJRNt7xLeA2qR0TwjYL
ZT7A+EGToMgOGkTDVLVWqof5R8J1Mm206sgOqBErOtIY+IV+E+MaHYJ8goxrz0TJ
mT8Xky3NgD/PfVPbCCOEuiViL21kTUcH9R9cJxoyUGs0GqjhvTrAscDhsqHCdeQx
j24N6TLdzpXMnawVtRVyv2y96blqgQ9LogdNTFdNJXSS1x5PSjmA119x9OTsKPbY
3hknlCwuQKGKuOqlxEyXmGbdP87DArqkzqT16qiqPFz233rmv7zRbjfPGMU83d8=
=CCi3
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Jul_2010_15_38_27_+1000_m3wvQ4zH7PA4OTwj--
