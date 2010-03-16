Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933Ab0CPRLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:11:05 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42851 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756818Ab0CPRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:11:01 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2010 13:11:01 EDT
X-Sasl-enc: 35KlHbtIeWOTc2w0s17KPUr9CFn8vbvxD9drAaj29m2Q 1268758933
Message-ID: <4B9FB8EA.1070008@imap.cc>
Date: Tue, 16 Mar 2010 17:59:22 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: bug list: range checking issues 2.6.34-rc1
References: <20100315083008.GK18181@bicker>
In-Reply-To: <20100315083008.GK18181@bicker>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC06588C43BF4AA4B531041EE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC06588C43BF4AA4B531041EE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 15.03.2010 09:30 schrieb Dan Carpenter:
> drivers/isdn/gigaset/capi.c +1305 do_connect_req() 'cip2bchlc' 29 <=3D =
29

You're right. That's a bug. Thanks for catching it. I'll prepare a patch
right away.


--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigC06588C43BF4AA4B531041EE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkufuPYACgkQQ3+did9BuFvbrwCaAnI35LSk5uKL+uliZ3lr1j2c
e18An25l1qUwv1f/SvRmy2n9lPLW5qTP
=8keU
-----END PGP SIGNATURE-----

--------------enigC06588C43BF4AA4B531041EE--
