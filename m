Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1KGQH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:07:57 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59381 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754316Ab1KGQHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:07:55 -0500
Date: Mon, 7 Nov 2011 08:07:50 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH -v2] pciehp: Retrieve link speed after link is trained
Message-ID: <20111107080750.14b4bdd5@jbarnes-desktop>
In-Reply-To: <4EB7FEF3.7090105@oracle.com>
References: <4E9147DE.3050006@oracle.com>
	<20111102140522.411ef343@jbarnes-desktop>
	<4EB23DBC.8050805@jp.fujitsu.com>
	<4EB7C14E.1070503@jp.fujitsu.com>
	<4EB7FEF3.7090105@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/L+v4U2.nohykPYXssif92T5"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/L+v4U2.nohykPYXssif92T5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 07 Nov 2011 07:53:23 -0800
Yinghai Lu <yinghai.lu@oracle.com> wrote:

>=20
> During hot plug, board_added will call pciehp_power_on_slot().
> But link speed is updated in pciehp_power_on_slot().
>=20
> We should not update link speed there, because that is too early.
>=20
> Move updating to pciehp_check_link_status() after making sure link is tra=
ined.
>=20
> -v2: compiling warning that Kenji found.

Applied, thanks guys.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/L+v4U2.nohykPYXssif92T5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOuAJWAAoJEIEoDkX4Qk9hXo4QALDrUZAnE4As1ZVoDR6dizFB
wAVHpnObi6L7Q5ldB0Fw8YG1O/drayO5nH9WNxw0iKz5/bztog/eQ98ynfTc+Iu/
BHc/1BxF2VCDM2ry+fv9ob0p7iEJDHfAYabih2X8uyKdmTZVRJs7tkH8BfB87mAQ
8DSy6rjpss/5teNF163Dvif4CEB3cp2di18VTkxdNIZwWpY+whY/A1WknVfwCDuH
Zt+Rx1HijCa6A8isWFR7CeHZKOK1oJ7oMeK9ZvDIMjb58vo75UkC7Q+yulitXSRa
WUH9tnGkT9suBEx4DgXYU8t9sT1Q+VCk8AvzjQpFrdfIu7fSy7ViWws+wSaZEruz
nSYvJZM9T7+/dKwKjIlIM38s+racSEw7tOTQ1ZogCLU8GKW7ZuV3LT/nEYdtqd7v
mWLgJp/81qEh6NoehSWNV3xZZ9alpnZhKD24chfPvl5yEjMXj/PRnePKBVRMf/av
nWHK41jMB33ynQkp4Nz36uPeNspukX/uIaTcdHeJEy8BIlkz6cE7l10AX4E/n1xF
RsaaU94wGXw2jvGQO/5cYXEzNsCEZDH8BjVSAAwFxG/604hv3QenQpwf73MYvcQC
IimbkPHEefUZWhSRls23GlCj+WOC+oF0dDSZf2QTtd16rVHaQQARzIDUFBIl4LvG
4Sgw4OsbN1V1xave7JDV
=U6yC
-----END PGP SIGNATURE-----

--Sig_/L+v4U2.nohykPYXssif92T5--
