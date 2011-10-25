Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1JYHFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:05:37 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:35148 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1JYHFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:05:36 -0400
Date: Tue, 25 Oct 2011 09:05:21 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Swen Schillig <swen@vnet.ibm.com>,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the scsi tree with the s390 tree
Message-ID: <20111025090521.51cbd1ce@de.ibm.com>
In-Reply-To: <20111025171601.c2365840409d17df161ca8b5@canb.auug.org.au>
References: <20111025171601.c2365840409d17df161ca8b5@canb.auug.org.au>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+n8C+7Z9Bo3gQqI3gbX.sIA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+n8C+7Z9Bo3gQqI3gbX.sIA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Oct 2011 17:16:01 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the scsi tree got a conflict in
> drivers/s390/cio/qdio_main.c between commit 9c20b3dd8479 ("[S390] qdio:
> EQBS retry after CCQ 96") from the s390 tree and commit dfe5bb506172
> ("[SCSI] qdio: base support for hardware data router with zfcp") from the
> scsi tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary.

Looks good. Thanks Stephen.

--=20
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


--Sig_/+n8C+7Z9Bo3gQqI3gbX.sIA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOpl+xAAoJELvpdr8mrl3Slr8QALTyrKDnHDCX40noaHmNzH8q
wA8aUIGQ4VoDSawyrdBK+5mSwDngIk7op3DobMKewdYDF9bthRvHGtNOHeA9/vPM
YrsIqSnJz+XQV6knajRjF3iI3kDYCHtFfPk8OseYGzGWvv1EfGEjacLEiPzFFZFf
+nWde8sRyovWEwTXoJKIIy8xipy1B9WSiMn+TzrILHuCUsm2yClz4qWL/k7/5UjG
UNTxlW7hYyyRI3cOuilAhhba9o6tq7BtQI5WhAgSCinh8Kh7GUNZK6esmt7FErcL
iSxTiup7EVtjqxhQFUdyk2h9V4B9NIawiWHLICLPLiwUxxXWgoFhmaQ+P39qjiVj
8DoHJaTyx9Jr4aFqyIUS4+v9jKzD9hnRl3UEq35JF/AHyZmpY5bA187/UKaP1eno
hVnm3nBwrZ2sE20odO850274O8OME0VN1DJcFmucUCG3dBgSUKhqzFrKulmzYjkA
X3o8a1ucYIwpg8t6wSSMgj8OTvbUJuKGZX45ZKwpHcup+cDkGgYF9aZgDkSeCnPZ
wogIaru19u7jg9PNCK8hRRehlHou69c+DVFYogN2BzJvqSlYDvTRPPRupXxkqrai
TMkAqUK31jUpu/5hv367s2nYICSfB69qZB+sRPazQEV5HIOVAHjDHMSc+hhI6ITm
NR+j+/Tm6pJ09/OkNUPp
=pIKP
-----END PGP SIGNATURE-----

--Sig_/+n8C+7Z9Bo3gQqI3gbX.sIA--
