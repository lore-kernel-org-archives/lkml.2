Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1CYFFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 01:05:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53973 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab1CYFFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 01:05:46 -0400
Date: Fri, 25 Mar 2011 16:05:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: linux-next: build warning after merge of the rcu tree
Message-Id: <20110325160539.659fe452.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Mar_2011_16_05_39_+1100_lwq+CmccrqN8yD7I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Mar_2011_16_05_39_+1100_lwq+CmccrqN8yD7I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the rcu tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

kernel/softirq.c:62: warning: excess elements in array initializer
kernel/softirq.c:62: warning: (near initialization for 'softirq_to_name')

Introduced by commit 0ac7e739ad17 ("rcu: move TREE_RCU from softirq to
kthread").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Mar_2011_16_05_39_+1100_lwq+CmccrqN8yD7I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNjCKjAAoJEDMEi1NhKgbsefAH/AnBZJRMc7GbOQYTNE0QWLbq
1J2TFwMVTMfCsPL0JEYpY1ue8KT78ze7Jk36y9kg4H6r8qHhadMktpl1PRTEDIQv
YvShI90jQLPg4q9BywkdbLID/yfOjV5ga6+Ua/np9TD21djTDU0YBMUZWqf5yV1g
uTkth6vqhUbp2S+L7yc+fKroGkzK545NpbcYEelkDjyWpruMAQf6YEVGPLMPz3P4
BP8ZhsJYXbgbd1N1JCUMD0vNfXJB2zuTplWm4+MWxHZ8uPv9+UyZpkW5PNksEjX0
0ZS36P6KURFcwkSi95LUIrcfExmWMAfMwfVRjjLxxRlXCHrr4vBh8qtEEysfPXU=
=aWnF
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Mar_2011_16_05_39_+1100_lwq+CmccrqN8yD7I--
