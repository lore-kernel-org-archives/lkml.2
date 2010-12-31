Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0LaCzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 21:55:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44635 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab0LaCzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 21:55:41 -0500
Date: Fri, 31 Dec 2010 13:55:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the percpu tree with the tip tree
Message-Id: <20101231135523.481cd14d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__31_Dec_2010_13_55_23_+1100_YNYE_HrIRjEihu5e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__31_Dec_2010_13_55_23_+1100_YNYE_HrIRjEihu5e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
arch/x86/kernel/apic/nmi.c between commit
5f2b0ba4d94b3ac23cbc4b7f675d98eb677a760a ("x86, nmi_watchdog: Remove the
old nmi_watchdog") from the tip tree and a couple of commits from the
percpu tree.

The former commit removes the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__31_Dec_2010_13_55_23_+1100_YNYE_HrIRjEihu5e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNHUYbAAoJEDMEi1NhKgbs+UoH/1PjwFMHIMhjNF5JdZ/xws1J
oAh8W9bslK90AsSZ3xhTnnMvFJOP1OVRcOAtlxRZ0+/GdCVzo3oAO5WFX2bwOtEp
ID5lPOzJ9OJwGEgpQbD6wTiBQa8a1IyWhnXIuHyp5xuiLVWHoVaxcz7sCaahBkHk
968DQUqgk+gX0GzYf4CRQyL98zPmV1CA96ycIrU2JyNWKuusYYBDcGC7yYJ5j0+h
nvENB7C8iQMyCLd1+wsmq1kY+v7h97MT5gvbuhhJ7pAYi8TXouleV/MjsZq24add
D/KS4Bi4mRCeapvmYlmz0/Ms+b9fktj9OJiI2bJ09knRZMDKXu8HNKwU7fUvqf0=
=fJE2
-----END PGP SIGNATURE-----

--Signature=_Fri__31_Dec_2010_13_55_23_+1100_YNYE_HrIRjEihu5e--
