Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab2BWQuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:50:11 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:39426 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753112Ab2BWQuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:50:09 -0500
Date: Thu, 23 Feb 2012 08:50:04 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RFC: export constants from shpc.h?
Message-ID: <20120223085004.17e32327@jbarnes-desktop>
In-Reply-To: <20120216145447.GA25979@redhat.com>
References: <20120216145447.GA25979@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U6PI+oWotV80NDBRgRtjQrQ"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/U6PI+oWotV80NDBRgRtjQrQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Feb 2012 16:54:49 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> I've implemented an shpc controller emulator
> in qemu, so I needed a bunch of constants
> similar to what drivers/pci/hotplug/shpc.h has.
>=20
> Any objections to adding a PCI_SHPC_XXXX prefix
> so these and moving them to pci_regs.h?
> PCI utilities can then use them from /usr/include/linux.
>=20
> One can see how a utility that looks at slot LED and MRL
> states might be useful
> (we'd need to export the base offset through sysfs
> to make it possible to use such in parallel with shpc).

pci_regs.h is generally reserved for architected regs, but maybe a
separate header file makes sense.  Or just patch libpciaccess or
pci-utils with your tool.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/U6PI+oWotV80NDBRgRtjQrQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRm48AAoJEIEoDkX4Qk9hqvoP+wWCIownLvvL8lOlyYwD1E78
STSV+RIMaO4zjv9mmJt1177K3APu+Ggx6R1OlV5+8OK8e+0ZTU5i9/YfgKbVuC7p
mIMUcMwaxUNZvbiyvfXTqz1rNcuZ3DmyJKKl9M38dPQFFKwFbIgM8lCIZhjYv8Mf
R+SrzLHi5tzgj8s9ZI+nnmOvOpyRFXByHz/koG41DwTv43Pfz2GRWPQ83WGaG/ww
sOYqUzicE3wlg58hJ7s74yUR5BqyU1nBsYOIj4gRu+7CzJbegv0GB6cIa70ZhizV
HgWQlGJGPz52iJwYPjMAmJJEAKHf2rYxbMAeqdAQRVp6hvRdGCj/+9aBlSZKZriG
+WhsezIhJ3TskKUSCCVlHAgllrAIhSAWJRzsJeh6ESMJUFmlWPWxeXnVP2K/Whpm
RXnuPPLa3smWmB9eTQIysbpHNDwsr6Dze/DlRHUx5QSnZjgKv7Q3f4hYEBpCxSG+
5pi7YkgovyJgA7HORSDGaR8u4NnUH7HOPqea+hyq4mpHkcCR6aGcqctRWDP/jFNh
25lt+Fjb1NimG8NpBg3aMcaQMpsm4XdLrpnk97qllIvYRR6n4aJrbKzG61Q3aFzW
9uUwvKZNvuYcY+4bm9e0xepc4LGjXEGT2XI4ZgeII9AqE1JekmpXR2jbjQTkDzhH
g90lytHgNGYQesIy455K
=/dKV
-----END PGP SIGNATURE-----

--Sig_/U6PI+oWotV80NDBRgRtjQrQ--
