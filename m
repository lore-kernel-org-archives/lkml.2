Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936983Ab0COW1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:27:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51463 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936949Ab0COW1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:27:39 -0400
Date: Tue, 16 Mar 2010 09:27:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: linux-next: build warning after merge of the security-testing
 tree
Message-Id: <20100316092734.7bf780d2.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LRH.2.00.1003160850080.13724@tundra.namei.org>
References: <20100310153116.291d4e6f.sfr@canb.auug.org.au>
	<alpine.LRH.2.00.1003160850080.13724@tundra.namei.org>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Mar_2010_09_27_34_+1100_cClD17E/5iUj/FwB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Mar_2010_09_27_34_+1100_cClD17E/5iUj/FwB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Tue, 16 Mar 2010 08:50:32 +1100 (EST) James Morris <jmorris@namei.org> w=
rote:
>
> Thanks, fix applied per below.
>=20
> commit 310de047eef6685274045db1e6b39c9f313df428
> Author: James Morris <jmorris@namei.org>
> Date:   Tue Mar 16 08:47:36 2010 +1100
>=20
>     selinux: fix warning in genheaders

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__16_Mar_2010_09_27_34_+1100_cClD17E/5iUj/FwB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuetFYACgkQjjKRsyhoI8yNpgCfZLg5vgAoIN5UH0jX8Ue9ChVb
G9MAoKsxK0QBXtJFb461mgwYtQh0YbAv
=IGQm
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Mar_2010_09_27_34_+1100_cClD17E/5iUj/FwB--
