Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab1EMEIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 00:08:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56613 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab1EMEIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 00:08:32 -0400
Date: Fri, 13 May 2011 14:08:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Vozeler <max@hinterhof.net>, matt mooney <mfm@muteddisk.com>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20110513140821.bfef61a3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__13_May_2011_14_08_21_+1000_TEfptzbUDc_shKjZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_May_2011_14_08_21_+1000_TEfptzbUDc_shKjZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/usbip/vhci_sysfs.c between commit d1b2e95ab016 ("staging:
usbip: vhci: fix oops on subsequent attach") from Linus' tree and commit
7aaacb43ed97 ("staging: usbip: fix header includes") from the staging
tree.

The latter superceded the former for the conflict in the includes.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__13_May_2011_14_08_21_+1000_TEfptzbUDc_shKjZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNzK61AAoJEDMEi1NhKgbsRH4IAIhyn/S7o53YHkpfZVQdJPUJ
AEaH/OEE3unpto5MAYlIIwIUKKHKQrqFYe7x8dQrLXZL8XWO8AlbK5wqUWwqHbB6
hDYT6GqZtLPYoFV2uWTIZ1AjjVFnlnXpUEZ0ueHBB8F/WzZi81VQxVDrq4huHqGW
4WYtkY5djal/xBePP/gtctWXZJnjf8MyLlIU6NyVFlfU0KjuyZZ0bXsDADsoWZ6A
Lo89poPogVAjXm5ntVyse6ICWFkEgw6Zoxk9K3JZekcWEC1r9xrafzcJsBqI0Ohv
ctuFG4RdgpvvYwXV+u8Y7f+QDrxzKvqcYBuK1Fd5GslyKWk02iZulEu1z5YV2nQ=
=OqW1
-----END PGP SIGNATURE-----

--Signature=_Fri__13_May_2011_14_08_21_+1000_TEfptzbUDc_shKjZ--
