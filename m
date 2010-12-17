Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab0LQB2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:28:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53264 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0LQB2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:28:41 -0500
Date: Fri, 17 Dec 2010 12:28:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the block tree with the  tree
Message-Id: <20101217122831.39300d94.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Dec_2010_12_28_31_+1100_26p.0OAzsgj.cltJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Dec_2010_12_28_31_+1100_26p.0OAzsgj.cltJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/scsi/sd.c between commit e765221e4b44b2141704a0ab201632446235712b
("[SCSI] sd: improve logic and efficiecy of media-change detection") from
the  tree and commit c8d2e937355d02db3055c2fc203e5f017297ee1f ("sd:
implement sd_check_events()") from the block tree.

The changes here are a bit extensive for me to figure out, so I used
the block tree version of the conflicting code (there are other changes
in the scsi tree as well).  I probably needs checking.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Dec_2010_12_28_31_+1100_26p.0OAzsgj.cltJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNCry/AAoJEDMEi1NhKgbs520H/0Vo/+15rmNCDUtSipHnxBAf
nXdwZg6gW7JjtTbQPoAqi+T7oHR1efeJLo/+UF1wRR7HbSY2NcIbvGgFNgKN2e8c
rsvI/vtLy+B4pKUePV0P9dhhKc6D60yUi5n9uKZUm2sqqo/yqxF5OFoRt3yv5s3P
hsPyUhnjDHz7yWndtDgEo/a2iEzu5fXaXawXS8sh6Y9ZqZBvZfUU/H20e1kS4/gb
IqCI8J2g87A1FFPfU4/yN2Q8oVNI6EAcgliM5fTld0Rjnpe28C0za+bbfwT2pTIw
udQle/cFrlLvGTVdKSrG070K/QIoewMbfcjh+HzfBJNPisOiVzE7/GZZsYbLQKM=
=gn5/
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Dec_2010_12_28_31_+1100_26p.0OAzsgj.cltJ--
