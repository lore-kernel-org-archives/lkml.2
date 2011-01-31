Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1AaCap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 21:30:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35272 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab1AaCao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:30:44 -0500
Date: Mon, 31 Jan 2011 13:30:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: linux-next: build warning after merge of the cifs tree
Message-Id: <20110131133038.ab3aa826.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Jan_2011_13_30_38_+1100_wMrsxPXLX2zOCCbd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Jan_2011_13_30_38_+1100_wMrsxPXLX2zOCCbd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/file.c: In function 'cifs_iovec_write':
fs/cifs/file.c:1740: warning: passing argument 6 of 'CIFSSMBWrite2' from in=
compatible pointer type
fs/cifs/cifsproto.h:343: note: expected 'unsigned int *' but argument is of=
 type 'size_t *'

Introduced by commit 72432ffcf555decbbae47f1be338e1d2f210aa69 ("CIFS:
Implement cifs_strict_writev (try #4)").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__31_Jan_2011_13_30_38_+1100_wMrsxPXLX2zOCCbd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNRh7OAAoJEDMEi1NhKgbsMuMH/A+TL4smYknOI+lPlnPhyFLV
aec6PCTwWhqQMoAiDILTju4fzHJC8t/ZXdc9pVItcF5sCnX8R90XzWdpQCyJdw4p
BUEkxOo4izbrNSYGpVUWfhcpnuGVMoz97d5U6GqTcjjt9GoMA/euOH2ZR+gzNrDa
tVJsKhYgZ5X5R0jinTXESZ82VHuwTY2SivmEknFuRWGgZPnbuZwgrUUTJDENL/zD
qjETWDr2eE6BbamnhfZb9i6oTu5V4qA2lYq5sTkus1YzY0jxdabLqqHWQ1v5qE8W
TkcNN0HebbbVtluwJu2mf6dwRAti8E0dWa333FvTLZtKG1KoCBFc1g4YovI/50I=
=LJtI
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Jan_2011_13_30_38_+1100_wMrsxPXLX2zOCCbd--
