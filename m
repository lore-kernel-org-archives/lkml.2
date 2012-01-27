Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab2A0SAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:00:13 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:33696 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752858Ab2A0SAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:00:10 -0500
Date: Fri, 27 Jan 2012 10:00:04 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/21] PCI: Make rescan bus could increase bridge
 resource size if needed
Message-ID: <20120127100004.18ffff4d@jbarnes-desktop>
In-Reply-To: <1327140517-14811-7-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
	<1327140517-14811-7-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VmAONftPwpCtTQByuQSNPRq"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VmAONftPwpCtTQByuQSNPRq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jan 2012 02:08:22 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Current rescan will not touch bridge MMIO and IO.
>=20
> Try to reuse pci_assign_unassigned_bridge_resources(bridge) to update bri=
dge
> resource, if child devices need more resource.
>=20
> only do that for bridges that all children get removed before. So do not
> release resources that could already be used by drivers of child devices.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---

Applied, but I fixed up the comment; please check for accuracy.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/VmAONftPwpCtTQByuQSNPRq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIuYkAAoJEIEoDkX4Qk9hO+kP/ijfFNTqc48GJoNsDSm5i8B2
cSYZ3yfMvpU+L7kqI1TU81C4+LyKs5l73XWKjFvFzRy8wJ8dSazbDprs1/l0oxYe
AEdjXJQo+SGsLlYgTaiQDnxTYyfFeA568LfOUOyy7+v1AW/DUyr+q5q2RExXsFbK
xuYCv1mhF36UBsP/ZrMFjttmrpO+kexT+RAxeniEhEoR/vGvRRP2ipD/MQuXx2Zh
LaSl/P/UJWvtlH/R3JR0coNR19yJwIQgQsLZr3MQrKsUBF//2hrgYPvs53ltmxo0
za/hUZL0TaNM6MybHeaY6DkPIfxrPSqzJx6wolS8Rtvu5LcrFCLp79Rxfmk3fu7i
npwrPP/oLE5nTp87SkEtC6ClOpHGBg/eIjFJAL8sga5TsCF9X3djzxlas8iC04aV
8yn1QK2jNXKy8yStP4KFA+mHr5/z8H6HbAI7LkUsJ/LsCGn1qlNrDN6UBtLVrd0x
2lShYiQBDdT6Cr7r71V5K3Ty1+rUBviMCMzrsvbedFW8CD9Pk7N1lqx5QvAE4eoq
XJMCXBI+dexHRsVBAc2ixfoXH9vsa19ikHwkzqFs53FeCXIYoAgIWE4mB/85ly5j
alnYVQlA1RwIBwSZ0NnNFMLcyJdGQDrcq75qlYjj22kTo+1i35oJr5T+5/hF/kSf
8zH7owYgLakemKmkHUde
=N4Y1
-----END PGP SIGNATURE-----

--Sig_/VmAONftPwpCtTQByuQSNPRq--
