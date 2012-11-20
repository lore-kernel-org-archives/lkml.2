Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab2KTNh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:37:58 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:52883 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KTNh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:37:57 -0500
Date: Tue, 20 Nov 2012 07:37:57 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: zynq: Remove all unused mach headers
Message-ID: <20121120133757.GY1718@beefymiracle.amer.corp.natinst.com>
References: <1353417817-15513-1-git-send-email-michal.simek@xilinx.com>
MIME-Version: 1.0
In-Reply-To: <1353417817-15513-1-git-send-email-michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/20/2012 07:37:48 AM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/20/2012 07:37:48 AM,
	Serialize complete at 11/20/2012 07:37:48 AM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4OpS+d6oOtUQaRm1"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-20_01:2012-11-20,2012-11-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4OpS+d6oOtUQaRm1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 20, 2012 at 02:23:37PM +0100, Michal Simek wrote:
> Remove empty unused mach/hardware.h.
> mach/irqs.h is unused because SPARSE_IRQ are ON by default.
> mach/timex.h is unused because of CONFIG_ARCH_MULTIPLATFORM.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Tested-by: Josh Cartwright <josh.cartwright@ni.com>

  Josh

--4OpS+d6oOtUQaRm1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQq4e1AAoJEEef0niEbw+lxgAQAJcqj2SLTcy+Zt1lJWpBKzBK
IQ8SFTBbxo/EFOOWdQckkSNnASq+g+6tD7dg2AYp00LFY9z3nzVRu2hga9cT1FDg
FCOqadS49soFmVBAOsR3HhSxWPP9VyPWQ+jmXumAlssRmcFETqShyEuHkpXq/NIr
dUcpkWBOGYAGqpne3VXanoxTstVzUtkM6FGisY9Ap8cb2SPL79rFKYNU59hASzSo
Mj/qJC3Eh+UDsea0PRJB5eNCfSxlhdJihrlqxgcsvWp8OX03ImKVVQ68cgI3d7rx
huq8Cren+bIK/w+TkXL+3VxeQ/DtkVA9FE1H6kvpTVCbe227ZnR+p0Uddh1lDEFd
Ba8ZgRn0hU87XgKdkthoc+5CX4iScvA0TR1RmKjHpyygzENX6wzXeNWKG2Cz5PtV
9UHLgBUi1sK4Q2e71en0phzu8uOQ2xyRGCNcMqCEhewtoG0o+fw2z2cszfckGGBW
nrZr317y+wfPKnfJMDb9tzkGl/f6htL+3WSyUbNQe/1HzVoq9VH9iaCQm0JNAaI1
OksRhvrbfMswpPQ0CAOQuioxbD9fxZsTSZijDMpX7g5HMylviRAKmfWds69/P99D
XuIwCM6tKGc9MTHcYtTBPqC21l2+SPzMiudm/s3eOyg6uAMY8VLG4fQnN1vSwzEZ
QpCqfFpIy40v9IQ6rMJs
=+53E
-----END PGP SIGNATURE-----

--4OpS+d6oOtUQaRm1--
