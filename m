Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1LSLpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:45:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab1LSLpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:45:36 -0500
Date: Mon, 19 Dec 2011 22:45:19 +1100
From: NeilBrown <neilb@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: TWL: add power off functionality
Message-ID: <20111219224519.05c81112@notabene.brown>
In-Reply-To: <20111219113645.GI11800@sortiz-mobl>
References: <1321177790-5886-1-git-send-email-grinberg@compulab.co.il>
	<4ED205F9.3070908@compulab.co.il>
	<4EE71FCA.8040000@compulab.co.il>
	<20111219113645.GI11800@sortiz-mobl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gxxX+ZKnziDTT3yTTVxaIB="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gxxX+ZKnziDTT3yTTVxaIB=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Dec 2011 12:36:45 +0100 Samuel Ortiz <sameo@linux.intel.com> wro=
te:

> Hi Igor,
>=20
> On Tue, Dec 13, 2011 at 11:50:02AM +0200, Igor Grinberg wrote:
> > Samuel,
> >=20
> > Can we get this one into 3.3?
> Afaiu, af8db1508f2c9f3b6e633e2d2d906c6557c617f9 needs to be (partially)
> reverted for it to be working. Is the core PM fix queued for 3.3 as well =
?=20
>=20
> Cheers,
> Samuel.
>=20


Already fixed by

commit fe6b91f47080eb17d21cbf2a39311877d57f6938

NeilBrown

--Sig_/gxxX+ZKnziDTT3yTTVxaIB=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTu8j0Dnsnt1WYoG5AQIyuw//Zxt76fW2xhJQYTXA3fEtX/9T5lzwY9oe
Bhga0CWxTBuITfZShtOu4Nvl6Z0kZTRcnDRREtds6Gst031qcaH10YfxYDLJXDci
EEzH4/OeQq4rV5H9aLKp/7pHbu08n1pjQcSM52HkS0nFmdqVKHOhywQY35hw19ka
JS12wZXCSguWXc1v8MEDp8m4WowLaeBEawIciGJL0JR2iWbKGge7EwmNUf6jLQlt
hMXqBLFI8aSSp9lM4haYRXzrcIdFbSP0dwol66ktgwj5Hcj3s/7uVbX4rNWFrn3e
yaoTJ6SL3hdicsLUhlhB1diG8t/CGFY1loCHoewunHkTI2oQVBXlvBlOlGgOMtsv
33fYBOESs+ZNpY+wtd0eccyIZ4a+2wvTQUsgGm5OO5tqVNjWOxrkW1w0OxKVtjC0
cvkBXTbJD3JtwlcMJgzBrjVfM3/wtJmxdqwFdu4EILFcmOaJYVz70AtNmdaz5Ecf
UNNC4siAW92hEaU+NNxTlxw95lJRSIW2ZDn9uKhYHIYFE3GMArKEx6Uh99HF6HNu
su3GWnEUDrCRTf6xo0o6E5uJJM3MNFzBx2KEaBu1M0xFcuHILiWPLD6dCec7/yZI
tcf3nc8XL4kf5bJiJaKxN5ZssKVMAy87OCsUl5X+rFH2vmKH3XVYoSQIjyZ5KRzk
jM1ULGHQjy8=
=r0f3
-----END PGP SIGNATURE-----

--Sig_/gxxX+ZKnziDTT3yTTVxaIB=--
