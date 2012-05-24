Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab2EXFy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 01:54:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49492 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab2EXFyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 01:54:55 -0400
Date: Thu, 24 May 2012 15:54:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: manual merge of the signal tree with Linus' tree
Message-Id: <20120524155453.7bd918b67bc73c444c7ad594@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_May_2012_15_54_53_+1000_Et7QwRYhMN5rH_kw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_May_2012_15_54_53_+1000_Et7QwRYhMN5rH_kw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
kernel/irq/manage.c between commit f5d89470f91f ("genirq: Be more
informative on irq type mismatch") from Linus' tree and commit
501a0effacfa ("genirq: reimplement exit_irq_thread() hook via
task_work_add()") from the signal tree.

The latter removed the code modified by the former, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__24_May_2012_15_54_53_+1000_Et7QwRYhMN5rH_kw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvc0tAAoJEECxmPOUX5FENwwP/RYxzry2BI2WbT8d0tQE78Nl
lWlXUaU+x3YeMeoFBa+1Nq7Clj8GMhDSnhTJ5Fdv0cT4XWXfS4paonrtB8rzcgm5
NcbLgk7kr7RcI57kQMPjn5jJSn+QMiOtRplWMSuvpwlr7BYSW6tswf8ot65Mz95P
x6derI+LFHM69qZ38Tlg50xoPKi91OxTliPO1WtI5rMN82l0m/gaVwtvMCVC0KhZ
gY/pBwSn467CNzbCPxYtAzew6D9cfAxia1dlvBSKRtYf6DDUlonbcGUod5ZKV6l8
2srQeP6dS/I+nlGq6gEnaZUsRzYU+6QHNZARjSIzy1LwnxlmFGuwzETcMCsM969e
1pU3LLGaRjolAtDz/gc+y6uGid7+Kvc1g8Lab/hZzEs+NP63c8B/0d7LwRMolrd+
+wP6DAjd36riiwo90fJdgtylDg+qpIVWxbHM+ogn16eijaV2p78RbyXuPaho3JNQ
bytsjpi4ODqCwXtOLRIRZnpPG1DP4rD36QMI1Zw7V97aRIH9GA2irnW9d+cgFbgR
EAm7SrrEkzJrUYMgfTMYRQ3KSDI3Egjdtex6JyG/H7HNY7ijGJRhAwqWbqR4YYIO
maTcS0juRgjdP2IeT8Mv0QLzgpeDF3ueHCoMa6wpov++4i86b+bsZrmnWxS2g0uO
Nl9sm1RkA6wX7/CACIVr
=CyB6
-----END PGP SIGNATURE-----

--Signature=_Thu__24_May_2012_15_54_53_+1000_Et7QwRYhMN5rH_kw--
