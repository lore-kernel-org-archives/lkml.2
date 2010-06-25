Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906Ab0FYEQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 00:16:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58655 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab0FYEQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 00:16:35 -0400
Date: Fri, 25 Jun 2010 14:16:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: linux-next: build warning after merge of the drivers-x86 tree
Message-Id: <20100625141629.43a7261d.sfr@canb.auug.org.au>
In-Reply-To: <20100625034141.GB15720@srcf.ucam.org>
References: <20100625132545.50e226e3.sfr@canb.auug.org.au>
	<20100625034141.GB15720@srcf.ucam.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Jun_2010_14_16_29_+1000_5hh=h5TyeLiYXKbZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Jun_2010_14_16_29_+1000_5hh=h5TyeLiYXKbZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

On Fri, 25 Jun 2010 04:41:41 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wr=
ote:
>
> On Fri, Jun 25, 2010 at 01:25:45PM +1000, Stephen Rothwell wrote:
>=20
> > RAR_REGISTER is also still defined in
> > drivers/staging/rar_register/Kconfig ...  Also, that commit did not move
> > intel_rar_register.c from staging ...
>=20
> Sorry, I managed to utterly novice git. Fixed tree pushed.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Jun_2010_14_16_29_+1000_5hh=h5TyeLiYXKbZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMJC2dAAoJEDMEi1NhKgbslrQH/iVp0XflCN8/L5sd7uU2Qe35
oWF6LV0Cd5IhqgIzHpG6AjjYPPsagWKJEecuKcXClJQvXhTEMOJFpCJeVMj6MWKc
rydQHhLgwcm5ovBaSBF/cerorAw7SkFq70zVTfpgTTVT1Hv/YJpcWJh1nKmYuGp2
bpi96wLttIdOkfPS39ROBr30S5yrckR6AmtHnAGf4jy+XF5Nm6RCZ2WIT1Rl9oOo
zSe6Ezw00WIxDSFsGHLamGMuhhYaU12/tAGI3Un1aqlHVOIAJ45m9zBrJ3ig9Egd
7Zu9Ed71qEZ5PbmV+Ujm6s4gviVZBzdRBwBJrJWDVTDgq7l4KmpkpBNarjVYZ/A=
=xHsk
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Jun_2010_14_16_29_+1000_5hh=h5TyeLiYXKbZ--
