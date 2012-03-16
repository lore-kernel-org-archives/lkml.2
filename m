Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031736Ab2CPNjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:39:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:48892 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805Ab2CPNjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:39:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="129749699"
Message-ID: <1331905305.3730.90.camel@sauron.fi.intel.com>
Subject: Re: [patch] Remove notion of key schemes
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 15:41:45 +0200
In-Reply-To: <alpine.DEB.2.00.1203161405090.2249@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	  <1329152067.22240.214.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>
	  <alpine.DEB.2.00.1203151545410.26775@eristoteles.iwoars.net>
	 <1331902271.3730.76.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203161405090.2249@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-LNoNq2imvAifuraOAFDm"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LNoNq2imvAifuraOAFDm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-16 at 14:34 +0100, Joel Reardon wrote:
> I actually just copied this comment from the comment following padding1
> and padding2; should they all just be omitted?

Ah, ok, ignore this comment then please.

> As for the ubifs being mounted with the old, it may be best to increase
> the version format number. The old version won't be able to 'read' (i.e.,
> decrypt) the data, while the new version has a switch to enable both
> modes. If new data is written by the old version then the new version wil=
l
> also have trouble to read it (unless we set crypto_lookup=3D=3D0 to mean =
no
> key). But its probably for the best to just let older version mount the
> security enhanced one as read-only using the version format as the data
> will be anyhow unreadable. Non-security-enhanced ubifs (but
> aware) partitions can set the version format to the older value as they
> will be compatible.

OK. Then I guess the version increment patch should also be separate. In
general, try to make logically independent things separately and keep
patches small.

--=20
Best Regards,
Artem Bityutskiy

--=-LNoNq2imvAifuraOAFDm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPY0MZAAoJECmIfjd9wqK0NigQAITtimU3lFDVbqAwWrhLu76+
PDwWUR653lvEqIG5+nWvVjgJoV9160YIp1RCvb01mvz+AmfVlKCgy73VaMe375H2
2UwfaZAKBLbDFWta9nFFSq00v4aCweQrui0HnthwAAp3JC+poK85RBxxq/3Q+crA
02c0g9Mm2uR17N4TVdZJWRAHkwmgV8/IVN54AHWqhMB0g9TBz1+9cymcNpZwpkCn
Vuy6R67PpRpgrvk+20zfXRzHkM/pmmaRBYSzNFHpn3ZQG+f+gdX6sLZMESwJfhl0
jvt7nj+NhPOFYaZ04Iwg1Td+AU6WyaPVpgx8Y31ZfY/1l5sCFBp1q9gpSX7DT3sf
fm1v3awTxbnSAilTSnYpt87OSNOKc2Y6MiGQLXioIw6NQyI+ICx3pBGd9Hoa3Ry0
oH9vKx/0e5PdB319O3JC8LSY5ZXV3dcZ5VN4Jp3uewibIbQPmtydqCC4U6k2qMxX
Sb7KDeDymoRR6xoQW5dRR75/8bEDTeDPy1yoUdldIic1hlQtig14w44ewdo/QBcs
iKGtSoDKsLx6Cez3oSXrfP6xTFfDEQu5veJpjKEHp4ZaENVvbV+ODCe6y0HseX3k
l8aFlJWABzcgU6vHpLCjkF7mFl2l2lc/poCOZVNS67S+mc7n2h7Y+sIrNtYXYnd7
8bQwomFjuQOnBwuxQvAc
=j0D+
-----END PGP SIGNATURE-----

--=-LNoNq2imvAifuraOAFDm--

