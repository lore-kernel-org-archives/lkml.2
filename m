Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab0LIDCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:02:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58787 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721Ab0LIDCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:02:16 -0500
Date: Thu, 9 Dec 2010 14:02:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, socketcan@hartkopp.net
Subject: Re: linux-next: build failure after merge of the net tree
Message-Id: <20101209140207.967a5ad5.sfr@canb.auug.org.au>
In-Reply-To: <20101208.183942.226776000.davem@davemloft.net>
References: <20101209132836.6f6acfb8.sfr@canb.auug.org.au>
	<20101208.183942.226776000.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Dec_2010_14_02_07_+1100_ywj4ePD4lablXUF7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Dec_2010_14_02_07_+1100_ywj4ePD4lablXUF7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 08 Dec 2010 18:39:42 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 9 Dec 2010 13:28:36 +1100
>=20
> > After merging the net tree, today's linux-next build (x86_64 allmodconf=
ig)
> > failed like this:
> >=20
> > drivers/net/can/slcan.c: In function 'slcan_open':
> > drivers/net/can/slcan.c:568: error: dereferencing pointer to incomplete=
 type
>=20
> That's amazing that with all the header files this driver includes,
> powerpc somehow doesn't get the task_struct definition :-)

It was an x86_64 allmodconfig build ... but yeah (I assume you still test
build on Sparc ;-)).

> I'll add the obvious linux/sched.h include to fix this, thanks!

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__9_Dec_2010_14_02_07_+1100_ywj4ePD4lablXUF7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNAEavAAoJEDMEi1NhKgbsQswH/293MTG1DbrF+SME8Y/I3NUu
5dtJh9A6B6adgE+4V2GQmVzLEm7IF25jUcsi8yErCmtMyzeSr4BaoXGTZrm15bGc
i2eA+DNF2SgzxxpAOxUYXILy63WYYmPO1tvWx9Ae+gqhdmtRyIBkpZHQZ1DaBE8V
+xyVJnb38L07fTXSR0eiZz/lUxrBUGw+ABaGIDmUfKg9XBWd8k2v7E7h+zqvqnrW
cT9MXNOQqdZOwePgVd93pPMZX69fY18mq/In2+QC3x9gyKtwyssW7SpAfhpiWATE
b4GpDKk+UJha1xnw24JCO6pcumCRvTZKlZFJxatJm+pgyRigzy1gEHE00/U6TMk=
=d43p
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Dec_2010_14_02_07_+1100_ywj4ePD4lablXUF7--
