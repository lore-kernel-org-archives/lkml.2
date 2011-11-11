Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab1KKRby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:31:54 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35424 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757283Ab1KKRbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:31:53 -0500
Date: Fri, 11 Nov 2011 09:32:12 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/2] pciehp: wait 100 ms after Link Training check
Message-ID: <20111111093212.3cceee91@jbarnes-desktop>
In-Reply-To: <4EBC21C0.5070806@oracle.com>
References: <4EB88238.4050409@oracle.com>
	<4EB8F434.6090003@jp.fujitsu.com>
	<4EB94A51.6070809@oracle.com>
	<4EB9A50D.1040302@oracle.com>
	<4EBB7F9B.8050703@jp.fujitsu.com>
	<4EBB8058.6090500@jp.fujitsu.com>
	<4EBC21C0.5070806@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Cnb5zmVCq1=OldTwZdAmrd7"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Cnb5zmVCq1=OldTwZdAmrd7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Nov 2011 11:10:56 -0800
Yinghai Lu <yinghai.lu@oracle.com> wrote:

> On 11/09/2011 11:42 PM, Kenji Kaneshige wrote:
>=20
> > If the port supports Link speeds greater than 5.0 GT/s, we must wait
> > for 100 ms after Link training completes before sending configuration
> > request.
> >=20
> > Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>=20
>=20
>=20
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> Tested-by: Yinghai Lu <yinghai@kernel.org>

Applied these two to my for-linus branch, thanks guys.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/Cnb5zmVCq1=OldTwZdAmrd7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOvVwcAAoJEIEoDkX4Qk9hQUkP/0x4u3lo3C9dil38Q/jOVqG6
YA6v9D7um5EHTTZyeeeTGf8ZXrh0ZxOAIlIXC8WUCc4y2z6ilaKWL7yBFQ4q0Od7
AeVE84So2ZFIHZfHRQfwbrwVExsGVbvbYpdjt7NToUdEJ0GabTMBsq95ilQ6IKMA
MOk1bSUxsbAAATc5S61EsrqlKPy1VdFW+vTezfjtRjjKx2Um7f8sf8txDCEykJjd
UdCVIMoNuRzZc/CPpHV2k3JzD0XcfmywXpUBWHJmMUj03ft+CMPcih8b9DRHdkF7
SIokL47x/PnNkJo3/vgIqO+EXAijhQahrQfdGESjcq5wsRgcK6q0whwqCTjF/av5
qUq4Nll0+PvsbPTDrDEsCLdiXa4dcw98r9HtBKmiPPpNYIKrHb/xNpuovnje5sgh
H4GQ9Dcz/6Lk83OTzeKPRN/nJ9rMZeIsM3zcm63BSnghO7dDjxrPiJjB1sF+eqS5
07KzUFBOrCaFk1bwAQRrfw6JVhxhckgQcXi77BIXLob7IHKhV4gD2cMWLsU7OxIp
oKanmtEs2erhnZOpRHX8P9txtCw4xvz8klInK18R/yiPFOD0wNUrmlWtSMUuBL1o
wdGuJJNBmNNehVOFR2zN8X+V1VAlCaub/A1ppe+snzz4BnImo/9M82SdvmSFwNDZ
yJvVnOumMUyfi2C/lFwq
=M8YV
-----END PGP SIGNATURE-----

--Sig_/Cnb5zmVCq1=OldTwZdAmrd7--
