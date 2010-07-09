Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0GIGeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 02:34:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49511 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab0GIGeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 02:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x9QfWRGDmCeIEuaS7kxjA+OccR5cIiIAzNbX8ej4F5u0gpGPzDlO+6oFDHRPB9f/ld
         R08wjJtWcF3mz9Y/ItE5wgNSxmj7gL4hlMcASzwNnWBxjMiUj3iKyg7ZklWs1Pwi9xN8
         PNUYMqZOrxWlph34InUqF3cbGUoAqwY2WDKhs=
Date: Fri, 9 Jul 2010 09:38:36 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Sedat Dilek <sedat.dilek@googlemail.com>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #16169] Complain from preemptive debug
Message-ID: <20100709063836.GA3965@swordfish>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
 <TXb9XdQzJoD.A.SIE.FOmNMB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <TXb9XdQzJoD.A.SIE.FOmNMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/09/10 01:41), Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D16169
> Subject		: Complain from preemptive debug
> Submitter	: Sedat Dilek <sedat.dilek@googlemail.com>
> Date		: 2010-05-31 10:10 (39 days old)
> Message-ID	: <AANLkTilTnAAZIizKinYsxFkNTkrmPqk6XJJuUjjhJ7EP@mail.gmail.co=
m>
> References	: http://lkml.org/lkml/2010/5/31/77
> Handled-By	: Dmitry Monakhov <dmonakhov@openvz.org>
> 		  Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Patch		: http://www.spinics.net/lists/cpufreq/msg01631.html
> 		  https://patchwork.kernel.org/patch/106555/
>=20
>=20

Hello,
The patch (Signed-off-by: Peter Zijlstra - http://lkml.org/lkml/2010/7/1/32=
)=20
is already in the kernel. Please see this thread
http://lkml.org/lkml/2010/6/15/309

8c215bd3890c347dfb6a2db4779755f8b9c298a9


	Sergey

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkw2w+wACgkQfKHnntdSXjStNwP9GIYZBMS4QNPBCeYfSRMZSIO1
ahY0ALKDDVBeiqAURMYYErVfIMD1S+W5ZKnpKiuAjbDDrJF62glAlI8zuC/KcEP9
mRcI4gUysqsfBqr1A6/lvN49ANhV2Gh0pITGttIvNZFqcbkqAnaQRtKnF7sOqdy5
bLif4D0jJobLrxWG/1Y=
=qbIT
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
