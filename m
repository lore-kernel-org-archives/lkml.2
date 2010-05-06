Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0EFXqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:46:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39365 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab0EFXqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:46:44 -0400
Date: Fri, 7 May 2010 09:46:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the logfs tree
Message-Id: <20100507094638.11351234.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_May_2010_09_46_38_+1000_fH_9Wwb6poBiU193"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_May_2010_09_46_38_+1000_fH_9Wwb6poBiU193
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi J=C3=B6rn,

After merging the logfs tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

fs/logfs/file.c: In function 'logfs_fsync':
fs/logfs/file.c:225: warning: unused variable 'super'

Introduced by commit c0c79c31c9d5fcc19812c6c35f842baf50ee788a ("logfs:
fix sync").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_May_2010_09_46_38_+1000_fH_9Wwb6poBiU193
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvjVN4ACgkQjjKRsyhoI8xSFgCgs8K0FiLPkgmiIRva5lgo1NJk
T4EAmgMVDo9lL7hAClj9xXYhGG/g7liY
=xowy
-----END PGP SIGNATURE-----

--Signature=_Fri__7_May_2010_09_46_38_+1000_fH_9Wwb6poBiU193--
