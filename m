Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1AaEHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 23:07:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59646 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab1AaEHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 23:07:38 -0500
Date: Mon, 31 Jan 2011 15:07:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the suspend tree
Message-Id: <20110131150730.14b05bef.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Jan_2011_15_07_30_+1100_zwfy0hoNeYUiGi37"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Jan_2011_15_07_30_+1100_zwfy0hoNeYUiGi37
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the suspend tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from drivers/base/core.c:27:
drivers/base/power/power.h: In function 'rpm_sysfs_remove':
drivers/base/power/power.h:71: error: parameter name omitted

Caused by commit e70e026805c518b1a6e11bc867b14815ac4426df ("PM: Do not
create wakeup sysfs files for devices that cannot wake up").

I have used the version of the suspend tree from next-20110121 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__31_Jan_2011_15_07_30_+1100_zwfy0hoNeYUiGi37
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNRjWCAAoJEDMEi1NhKgbs3TwH/0wQALdIg2s1BUrXmdoRFy0l
6ip/Hlmoo6heIe3rsSitiR++pV/Pv9ETKk+U9yR9cAbMeyVZB4zux7LCY42GHIGy
u2dKe15qHr3EHSGARA1/fyi1HvGJvHRo9U0mg4lpXkPeaDy0HhJSeTtdAyxLFkoN
kBDKgl3ZYTy34xwL2eGxVeNfADma8HSJoekaQeHFSoN0OSws2OfL7gjjuFb5UhMn
rDc6tSEWz4IfBDGrqunDoZtgIdbw6ezVa2f/kZm6JU+v/hLeL4mmhrYyTy8S+t2G
vOykCT+EfQRI5IDH4z/A26JGAw6x8yTPI/mSe5vxRwVOrypgOsAfTQNeBFwPvBk=
=VuFK
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Jan_2011_15_07_30_+1100_zwfy0hoNeYUiGi37--
