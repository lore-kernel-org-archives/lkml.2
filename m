Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab2HQEBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 00:01:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50901 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2HQEBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 00:01:34 -0400
Date: Fri, 17 Aug 2012 14:01:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20120817140123.56bf158c14abc8fc0147bd67@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Aug_2012_14_01_23_+1000_vXW.IgAnRkv9XmLq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Aug_2012_14_01_23_+1000_vXW.IgAnRkv9XmLq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "device_pm_lock" [drivers/base/firmware_class.ko] undefined!
ERROR: "dpm_list" [drivers/base/firmware_class.ko] undefined!
ERROR: "device_pm_unlock" [drivers/base/firmware_class.ko] undefined!

Caused by commit 37276a51f803 ("firmware: introduce
device_cache/uncache_fw_images").

I have used the driver-core tree from next-20120816 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Aug_2012_14_01_23_+1000_vXW.IgAnRkv9XmLq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLcITAAoJEECxmPOUX5FE+2UP/2Ch1Avm4k74aB6dDZgKnF6S
hebkFA5XjYkRHCSxxDTrtqtkMqtjxP9q8iLXbeg96S/anfDA2qFbf4Na47pDuR9a
Fm52UbdpJ0m4qQXuZn7QuNbOvIsYRsZdaRPSlZqmJO8AlQbGtWJJk5K4dPBKo2Bg
1dIB8c7QvH5GVeK2v5FFIFeiV0uMlr7cEXezr7IWJkc75W2B2/SzUZRF1Zk0OnGh
loASSEi1Z1GTAfSfyvAole1M1myRbu5yAAJVGZHHUjTGYTMBSDV892b07gsw99rx
EQBo8a9VqyRpt3dI+gm0BRNZwez12MnxATD33Su9SdixyTA6qfxUo0JezJlA2iHP
xc0kVyjjF/hpmybOi8uFh9rRAUb8GdQ53HJpl4C34GboysJg/OBNx/wpvy02xW+C
20T6Q+bgCwZNaQbf4QrrLJACspP8jXpgFwj8+RWvQnRiSKOt9V9wusV1Oc1wAk4d
z7PBdbHtgTLHiwn8BWP5KkudnMNL0lwr86wCgUTzfYswJXqO0bNtRC58VhTmI3du
yDiO5VhW8waABLSf/t5oRd8tcALzgxc+MBF9tAJa/CnWWkcuS5Wpc8kCCNVBFMkg
89OzgJRsa1IYUkNj9RJ0UtzLrQotQzzT6C1HSp+70B9MTC5ODIzKQaGMzyyz6VUX
v1xfNpSApETit++wM0Lb
=h4Ce
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Aug_2012_14_01_23_+1000_vXW.IgAnRkv9XmLq--
