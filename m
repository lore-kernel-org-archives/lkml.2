Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976Ab2CNMis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:38:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42603 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760941Ab2CNMir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:38:47 -0400
Date: Wed, 14 Mar 2012 12:38:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, axel.lin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] regulator: tps65910: Provide settling time for DCDC
 voltage change
Message-ID: <20120314123845.GI3133@opensource.wolfsonmicro.com>
References: <1331710258-9459-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fckbADODYWZD5TdN"
Content-Disposition: inline
In-Reply-To: <1331710258-9459-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fckbADODYWZD5TdN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 14, 2012 at 01:00:58PM +0530, Laxman Dewangan wrote:
> Settling time is require when there is dcdc rail's voltage change.
> Returning proper delay time for dcdc voltage change to settle down
> the output voltage to new value.

Applied, thanks.

--fckbADODYWZD5TdN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYJE6AAoJEBus8iNuMP3dai4P/0Sns2DtZpergj8aZKwyBTmu
aMwAYrflSLBEop4UppxR9UdrrC0A+xF24+zI+40ujQ8yp8n0xp3dx+tFYouRFNFG
QvS9UIpMlSbet70rQZkJVHSTGsYwVBCcC+S+HbN+3bidtLi10ggiJrMaHatmEvlx
oZTUHaak2Qyo+YjipPzvCQR77Tbq6ErMZUOoU1G3Ar+UrbscDlkUqoH62ngSX4Q6
oqadgKphJh68Hca21pGiI7yyUxFVzkyvi0wBwpbj7lC2dVCFUst/ov22Px9n+ueF
HZ4oLFd576ZGfC1+aw4XoXB+HrWoXLK/l9/PB0CElwEGGc7kU1gmKRYWUBB/LRJz
M3GkGO+3f6R1iZZcuQdu3iZiMdZliwcuL2fpYO0gZ9N59G8pmFO35rwtbfiseEWE
lvcIIASkGwN8xypMAOAVmDWUIXtBjvvjJ9V1ihkVpQBfR8CkRRF28jmt6btEfueb
iWC3QsAYfehsiCi4s9QWk/ePZZy/CBUXAiVAqLBMyLBr5yXluDHWlZAWj4QsnAKm
YWqDMdVKvx93NGlgxZuqif+G0bSQFxCVfg53oFJsgSFSDpLlnYXEO+dpTW1OnAlz
9wZ8FEgmHscSC7TU8noe7UPkaj/fRAA8chFKkFq8Pp7V77i3Ks7b5Nto3G8JXV5b
ZuNPyg0HLwr0KIRKF4S4
=WjOP
-----END PGP SIGNATURE-----

--fckbADODYWZD5TdN--
