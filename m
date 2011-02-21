Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1BUCb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 21:31:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54765 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab1BUCbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 21:31:23 -0500
Date: Mon, 21 Feb 2011 13:31:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: manual merge of the hwmon-staging tree with the
 jdelvare-hwmon tree
Message-Id: <20110221133116.b802ebb8.sfr@canb.auug.org.au>
In-Reply-To: <20110221021708.GA7096@ericsson.com>
References: <20110221121944.57f2ecfb.sfr@canb.auug.org.au>
	<20110221021708.GA7096@ericsson.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Feb_2011_13_31_16_+1100_1Gb8lg1bAJxCeu4a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Feb_2011_13_31_16_+1100_1Gb8lg1bAJxCeu4a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Sun, 20 Feb 2011 18:17:08 -0800 Guenter Roeck <guenter.roeck@ericsson.co=
m> wrote:
>
> yes, it would be great if you can carry the fix if it doesn't make too mu=
ch trouble.
> I don't see an easy way around it.

These sort of conflict fixes are easy to carry ("git rerere" does it for me=
).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Feb_2011_13_31_16_+1100_1Gb8lg1bAJxCeu4a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNYc50AAoJEDMEi1NhKgbsZS4H+gMG8INkfcAZrKL7wkiv0G79
9IJcUKo6Z5hfI45EI6keJfOxS90H6On9ZncXdeunGW1Z5pQRsRH1c4UdC805Ybfy
/C1ILYQzzVnC2/iqlcSuPt1vb3OAPx64eew0e1jvHUU0BGr6pT8L+qMPiXzsMhj9
lMa4/zRlVbHNA+BEm1tH6AntZ9HwWvbEFoepV0MHQtGWv8x00el5H1Dic7SMEdaW
qTTXom4MB2+qtAhpy295SsrmdPrcKlRQ3jOE9wyYa9q59lPydfSqPGI+W0FPF2UF
P4GDvdElxkqBfz12cI3iN0pwSPS9Y2p+JBKfYxz5aJnc2mw9FL4+0+HoCG1+Ha4=
=oT4U
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Feb_2011_13_31_16_+1100_1Gb8lg1bAJxCeu4a--
