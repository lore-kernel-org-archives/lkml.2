Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab1IVBST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 21:18:19 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:36684 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1IVBSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 21:18:17 -0400
Date: Thu, 22 Sep 2011 11:18:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: Adding hwspinlock-next to linux-next
Message-Id: <20110922111806.4dd806f5ec14c219932e74ff@canb.auug.org.au>
In-Reply-To: <CAK=WgbaPkTpsp-Zp9FCQW5t4dMp6ogJtzL4nOgR73wErrvg8Ng@mail.gmail.com>
References: <CAK=WgbaPkTpsp-Zp9FCQW5t4dMp6ogJtzL4nOgR73wErrvg8Ng@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Sep_2011_11_18_06_+1000_8kydMMA7kgmEy2xv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Sep_2011_11_18_06_+1000_8kydMMA7kgmEy2xv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ohad,

On Wed, 21 Sep 2011 20:22:56 +0300 Ohad Ben-Cohen <ohad@wizery.com> wrote:
>
> Can you please add the following hwspinlock tree to linux-next ?
>=20
> git://github.com/ohadbc/hwspinlock-next.git linux-next

I have added that from today.

> (I'll most likely switch to kernel.org once it's up again)

Understood.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Thu__22_Sep_2011_11_18_06_+1000_8kydMMA7kgmEy2xv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOeozOAAoJEDMEi1NhKgbsQRgH/je23RSsiifzEqNSrgmTAs3q
O7NDUEcxGAvh75LWI3x2Vh8Yvn7/crVbIGiPOIyMfEa1mTYkzxyrBq1nCJ6I1zlD
xGdyvhfY4P0GbeZ7jxuX4vNmBLq/b7NiGBv9n+2d+MpT+Vm49lZi06zz0BIFFTfj
9xxFfpVycclFARoQTlsvNnmJcPRtzqAk3pCbcH1Eud5Syi7jmPfkMwepmOle92/3
/A18UEvYxaCwzTMNRmqOiIPfs/9B82DznD9j3p9DUgl4BNmGauNghUITzmg2eE8T
LWe4+VevjhWxI0/vOHrdEpAcPESNOOyZbQR2tGbldCIkMf0+JCtaev7uAi+QjxI=
=9D0G
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Sep_2011_11_18_06_+1000_8kydMMA7kgmEy2xv--
