Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab1H1SuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 14:50:05 -0400
Received: from serv132.fzu.cz ([147.231.26.132]:38741 "EHLO serv132.fzu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab1H1SuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 14:50:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkkDAHiNWk6T5xpZgWdsb2JhbABChEyjKxQBARYmJYFAAQEFI1UBEAsYCRYLAgIJAwIBAgFFBg0BBwEBh3CnHpAlhTuBEQSOFYUKhQ6LeA
X-IronPort-AV: E=Sophos;i="4.68,293,1312149600"; 
   d="asc'?scan'208";a="1699154"
Message-ID: <4E5A8DB5.2020100@flaska.net>
Date: Sun, 28 Aug 2011 20:49:25 +0200
From: =?UTF-8?B?SmFuIEt1bmRyw6F0?= <jkt@flaska.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Alexander E. Patrakov" <patrakov@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: IPv6: metrics of default routes on different interfaces (Ethernet
 vs. wifi)
References: <4E5A586E.90509@flaska.net> <4E5A6353.5020202@gmail.com>
In-Reply-To: <4E5A6353.5020202@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig31143D64781D99FA4D42E7A6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig31143D64781D99FA4D42E7A6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/28/11 17:48, Alexander E. Patrakov wrote:
> It is not in the kernel. You have to grep through the source of whateve=
r
> utility you are using to configure your interfaces. For dhcpcd, the cod=
e
> is around line 200 in net.c:

Doh, that completely explains what I'm seeing. The IPv6
autoconfiguration is not handled by userspace at all, AFAIK.

Thanks for correcting my assumptions, now I know where to work further.

With kind regards,
Jan

--=20
Trojita, a fast e-mail client -- http://trojita.flaska.net/


--------------enig31143D64781D99FA4D42E7A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5ajbUACgkQamXfqERyJRfQyQCfYcldYnzFztBGPB09i1v5Gjn2
jIQAniwq5jixX4b952pk+Lg0jASY5DWp
=2mtA
-----END PGP SIGNATURE-----

--------------enig31143D64781D99FA4D42E7A6--
