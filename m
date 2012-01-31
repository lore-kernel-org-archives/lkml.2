Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab2AaIEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:04:41 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:48869 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2AaIEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:04:40 -0500
Date: Tue, 31 Jan 2012 11:05:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?iso-8859-1?Q?V=EDctor_Manuel_J=E1quez?= Leal 
	<vjaquez@igalia.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>,
        devel@driverdev.osuosl.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] staging: tidspbridge: silence the compiler
Message-ID: <20120131080543.GA3294@mwanda>
References: <cover.1327964066.git.vjaquez@igalia.com>
 <d25cfe1b88f2b749cb31887d551a1c9b0fcde42e.1327964066.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tK3TaB1xs9ylLrl6"
Content-Disposition: inline
In-Reply-To: <d25cfe1b88f2b749cb31887d551a1c9b0fcde42e.1327964066.git.vjaquez@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A020204.4F27A07D.0048,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tK3TaB1xs9ylLrl6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 31, 2012 at 12:12:20AM +0100, V=EDctor Manuel J=E1quez Leal wro=
te:
> Silence the warning when compiling drv_interface.c
>=20
> Signed-off-by: V=EDctor Manuel J=E1quez Leal <vjaquez@igalia.com>

What does the compiler warn about here?  Normally you would cut and
paste the warning into the commit message.  But at least give us a
hint.

You could also reformat that printk so the message is on one line.

	dev_dbg(bridge,
	        "%s: vm filp %p offset %x start %lx end %lx page_prot %ulx flags %=
lx\n",
		__func__, filp, offset, vma->vm_start, vma->vm_end,
		vma->vm_page_prot, vma->vm_flags);

regards,
dan carpenter



--tK3TaB1xs9ylLrl6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJ6DXAAoJEOnZkXI/YHqRUYIQAIo5uqFcN7GIM8I0+i3+7N+B
Sacu56b8ASOxpZS5oeKD7sliRvwPF+cvhLsMcVsUsRIMcIXv7PVKkPfLj0F5YFfi
/nbeHshKVpe82fVYwbuPW882Pnz4oql4fQAbNtZ6cANKRoBc2zksGywA3BRWitv1
A1ldLfGknyzdCusR7dsD+pyPZ/ZEbDdeQ10/ffGE4CSZz/AcrxmSOAiSvNkD4IdS
3gGBt00htQNVROK2lQn0LkeEEnmG6qnxPHNmw253t6TnbPy9eSmvm/eUtQvwurXM
Epiy86bEO9JpmRcUlvfgQ+pQw22lY0QgiKUMy832V12x22HAvFDuFS5FWsCA2Kp0
sw8GKc9QCDJDabp2MNzuvwS6gDvkotJ3GL8ijgXkdEMUGuufSh38RgTYIip2mzKE
Or0xmcX1MfAwxneQ7WYtEkzE3487APdfbweNwyn82b5BxUS0hpPU0iXuvloP95Bi
lRc4cfECS4nAWg7QNIEgN7jn7bjV6zbvmC5qcesKgM9LJ+RmMjtuiz9Y4I9NyFXw
LDNa2qM45KEDRbYnMwsnwyqqXYzjyC2JJjd3R+d2yYqpwhewxfEkPv+EsXZa4MQG
NOVjIUsf7Tsff1pNNYODytNLIEi4qIZfOfM9c4dSle8jHTy2bOhlEijtAidy1bQq
aZV0TboY51oxHbmTfYXY
=sljU
-----END PGP SIGNATURE-----

--tK3TaB1xs9ylLrl6--
