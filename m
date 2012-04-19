Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab2DSAdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:33:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2DSAda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:33:30 -0400
Date: Thu, 19 Apr 2012 10:33:21 +1000
From: NeilBrown <neilb@suse.de>
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 1/4] lib/raid6: fix test program build
Message-ID: <20120419103321.4f261da3@notabene.brown>
In-Reply-To: <1334261073-14781-2-git-send-email-james.t.kukunas@linux.intel.com>
References: <20120412161805.133c4ad0@notabene.brown>
	<1334261073-14781-1-git-send-email-james.t.kukunas@linux.intel.com>
	<1334261073-14781-2-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3k_3o14y=wPcp5nF9yJo5eE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3k_3o14y=wPcp5nF9yJo5eE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Apr 2012 13:04:30 -0700 Jim Kukunas
<james.t.kukunas@linux.intel.com> wrote:

> <linux/module.h> drags in headers which are not visible to userspace,
> thus breaking the build for the test program.
>=20
> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>

I've applied this and the following three.
They should be visible in
   git://neil.brown.name/md/ for-next
   git://github.com/neilbrown/linux md/for-next
(a fair way down the list from HEAD).

Thanks,
NeilBrown

--Sig_/3k_3o14y=wPcp5nF9yJo5eE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT49dUTnsnt1WYoG5AQJeehAAjkq4AQnj182XPs5taL7h60bpsXcQUaU1
rgTKcQuBGq4CQC2/giVPYpHF0Q5x+UBko82z+oPi58sYnHHXy5l+2Vz0PmAqR4T4
GYDBWwSm5mkl5wudFV+BrsxrUguQ5YbIlYXCT1EeH3H1fo1N76pDedQnYrxtMNMh
df2F+r4cbS5T1ik+F5ZGUw6qQHXIskfJiNueuNwwUyIVX7mSu3A0LwqYBaFsyXg7
QZR3SgjKXON9CXq3h0yQMKWzmQ1Z6gvx0tSiphz0/J5EmP1402fIrO06N5WsXXdI
FnJuf+aiJX9sOIo/1GSeIao0a8mySlySWGQMhS+hBz+iRmObfiWKTexrOpYA/1o1
RpoObPaQDTlrVfS0KOp5AYTOOQf9cpUv2CrvTFAWI6+6WnNJ9NJ4oF4JaURHrMYh
5+sCLCk8RP+/Viv9y/bw5qyIdG95VuQzd18sXGnEQxk3KgbIuU3GYJGK76iMpLez
uz1NlFDV7YKFu+Y++58O31Gy8Og+Ls0GVXVYEY9Y01UBnmdRWBO7E/xw5CP9/RKb
Sxs1CX643nnSMwK2daK8xdMVX5nnSYIc3mUmaHHpqLowbDvYn/OmI1iU9IxN/6B+
4gETtolwsRTyS/alvPeV6a3aD9b7TM1eVDpLrN6Ah8B+9T8DQwwoHlZ/zVasyrl/
IgNnGMBChro=
=4Cis
-----END PGP SIGNATURE-----

--Sig_/3k_3o14y=wPcp5nF9yJo5eE--
