Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab2CACXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:23:24 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:36895 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab2CACXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:23:23 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Zhengwang Ruan <ruan.zhengwang@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Trace: initialize variable to clear warning
In-Reply-To: Your message of "Thu, 01 Mar 2012 10:08:56 +0800."
             <4F4EDA38.2070803@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1330420174-20537-1-git-send-email-ruan.zhengwang@gmail.com> <1330438591.25686.214.camel@gandalf.stny.rr.com> <48875.1330555230@turing-police.cc.vt.edu> <1330564158.25686.230.camel@gandalf.stny.rr.com>
            <4F4EDA38.2070803@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1330568597_2887P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Feb 2012 21:23:17 -0500
Message-ID: <3661.1330568597@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4F4EDD97.008F,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1330568597_2887P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 01 Mar 2012 10:08:56 +0800, Zhengwang Ruan said:

> > /* if you get a warning here, upgrade your gcc to 4.6 */
> >
>=20
> OK, I will resend this patch.

For the version with Steven's suggested comment:

Acked-By: Valdis Kletnieks <valdis.kletnieks=40vt.edu>

--==_Exmh_1330568597_2887P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT07dlQdmEQWDXROgAQIG5Q/+OEVFdJu9lDsV95hagzYlgJSSEqJfNSaF
tfZ/GK9rpilHnIU3JBGf6UDx/Y3jwhX6NBoWMEQ3v9NTbklwmmfGUg2+J0jjTzF4
FUsjbb8lY+YN0wMuyQCFnCe8qZC1vyYavNwZC29iCpnyZqARp+GjQN56U9gTZYt+
BP/fy2pLh/TkEkPvUS6CtE6edhZzPaEWI3IaGyyerEZ0YEl+okV2h1sgH2WC/Vzo
loHCMcvp9iNw4+e1PtLZT+m5slctj9BAEyR8GCoT+kqrR0eb1nclhftCOfX8EgLV
U8ELBaodLPbsokaLBR4jGRNLwh2biu98UJRHSrfQqFIIATosDQa3w9Ezey9QB2Z9
4gq3UJxen//VGc8Uk66XhZ5x8yd0jS9CLHlW/v56WaVwFZwINBZDnyt5F7Rmw9PG
cKzwwaWiL09O+kDbie2Tz66JXt8LaligOL2Wv22p67T6WQO0cQbpPODUPv/RdLab
h8eymmevZ7hbgfvWCf5WAi6VtZUNcgJSRypKhwQkv/QQ286F0yLdBgHMCHsPwly0
kv5LWiugp1raNqy4Vi4ddNYECD0Ffeaz7rEFo9yXaqFHp35JP1yVdDAIr0C014od
1qQQORs3Duy6EJPJ24o6gOP2F67Nrr6rCZ9TYgviKd402Kw1/LNA7o/wkLGHyzIo
Ma5qC7K5y8M=
=NfvD
-----END PGP SIGNATURE-----

--==_Exmh_1330568597_2887P--

