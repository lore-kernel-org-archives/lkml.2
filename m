Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab1I3BMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:12:44 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38856 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab1I3BMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:12:42 -0400
Date: Fri, 30 Sep 2011 11:12:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110930111241.829ed0ada733516b71ab120d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Sep_2011_11_12_41_+1000_OcJY2M1M7F0fPSxu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Sep_2011_11_12_41_+1000_OcJY2M1M7F0fPSxu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (avr32 allnoconfig)
failed like this:

arch/avr32/mach-at32ap/pio.c: In function 'pio_probe':
arch/avr32/mach-at32ap/pio.c:401: error: 'THIS_MODULE' undeclared (first us=
e in this function)

Probably revealed by the module.h split up.  I guess it needs export.h
included.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Sep_2011_11_12_41_+1000_OcJY2M1M7F0fPSxu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhReJAAoJEDMEi1NhKgbs7jsH/2vp0hXUod62kQIevU5LImBa
acfnLCOt6rjkKvMWisSlUkRQ3JNLuzoot2tGDL2FDFCl1fbOPG7yGXydH99EAUqV
Pfh+xBVGHIfzg1Lj2BJpGVxgBZ1pHTb7IStuI0PsUcfGnI/cMA4UOqn2Vt9jUjqc
JhXtwUhq0LzME7wfMnsYHEuJ6JKV96lXNaUoRJ9bMtXfbIyLHGHrVjJF/9pBhWWQ
5YMqhjVx7UuJrNXGiXv5NHjXaufKQe45gYBgo79YI1VPfsjb4syzPlNIUzybSFju
lPreZa6oWkevDQSTc8485hdIDrSXCUmYIslI9ZnWHXwxlrqh4JwGd2M4kyiaKEg=
=dGGG
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Sep_2011_11_12_41_+1000_OcJY2M1M7F0fPSxu--
