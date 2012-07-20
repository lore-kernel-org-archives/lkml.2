Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab2GTCss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 22:48:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35518 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2GTCsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 22:48:47 -0400
Date: Fri, 20 Jul 2012 12:48:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Christian Riesch <christian.riesch@omicron.at>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-Id: <20120720124838.2bd0f1e5087c4f08c5a65eed@canb.auug.org.au>
In-Reply-To: <20120720120118.465056f267ab5c3ac5ea45c4@canb.auug.org.au>
References: <20120720120118.465056f267ab5c3ac5ea45c4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Jul_2012_12_48_38_+1000_dVB_01ZF0Rp+ajtn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Jul_2012_12_48_38_+1000_dVB_01ZF0Rp+ajtn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Jul 2012 12:01:18 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the net-next tree, today's linux-next build (powerpc
> pmac32_defconfig) failed like this:

This was actually yesterday's linux-next - I guess it is fixed by commit
215029375c83 ("asix: AX88172A driver depends on phylib") in today's tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Jul_2012_12_48_38_+1000_dVB_01ZF0Rp+ajtn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQCMcGAAoJEECxmPOUX5FEMGoP/R9TyRWtqUh+reWTp1A+Fjt9
6PTqHFo75znSWn7XWCMHrFaU0Iub6rsrwO0MZk4SniDHHk4VFJWpt4tGhYweLpEG
QEK1DUqJ0AVE29iADxSdFxmxCjX8vnX6Lbm2H8bAnjS20RXLwjDNuzvjvC7MfwGt
Z+Fb0eeZYXSzxwuxQeV9kZAyuuEultCgMmOV3t1LesD5kQP2nuWYWPokA/oIhTCF
se98Tw9iNRy9kGLlZzKVA0wtj6pZ/iWYqtlrfsoCk1HHA4sbbn1PChtgTZ8GcT68
Em1ye807wq7uG8y3Z86dcJEQxlL72yJoyc9i/pGDfWTAwwQOpmnZE9bF5egF1xOV
bvKHQfFIfMhtFnwiPR9SJqwJHB1T6dj/rRA3xSkn9aVlxOixOOWQfbXwYfyKvosF
yJKFf5khOPeEOF9ZpemwKRCdR3ahF2Mlnekrh/+b3UTEEygOu10KoLOGKmnamNJi
XtIbCKZ0OJMiZodSblO7blER7yB6uIt695H/a0IGbeJpHKoDrolShOE6bl8XesHa
ZfaArDGdmzQCmnQtJyUVz4gSCG1cRqPSbySX0c/hljzg1YpLEwvmB0dO0JnljdSr
C2chWZimyAKyG3E9Jiv5u1jMiqO437sVTfP5uLV1e6XOhRs2RT8bHFIKtsiSXq1F
ksl6z8VkLXl5DWC1Mx3n
=xacN
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Jul_2012_12_48_38_+1000_dVB_01ZF0Rp+ajtn--
