Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab1DYBuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 21:50:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43464 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757964Ab1DYBuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 21:50:11 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Nick Piggin <npiggin@kernel.dk>, David Rientjes <rientjes@google.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
In-Reply-To: <20110421151117.733D.A69D9226@jp.fujitsu.com>
References: <20110421132442.7327.A69D9226@jp.fujitsu.com>
	 <1303361579.3464.168.camel@localhost>
	 <20110421151117.733D.A69D9226@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-I4UL/mmwDmMfcptt7xKC"
Date: Mon, 25 Apr 2011 02:50:00 +0100
Message-ID: <1303696200.3032.229.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [48/70] vmscan: all_unreclaimable() use
 zone->all_unreclaimable as a name
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-I4UL/mmwDmMfcptt7xKC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-04-21 at 15:10 +0900, KOSAKI Motohiro wrote:
[...]
> So, I think there is no worth to backport. Two years no bug report mean
> it's no big matter. And we can't make a patch which include the above
> three patch and its dependencies smaller than 100 lines.

OK.  Thanks a lot for checking.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-I4UL/mmwDmMfcptt7xKC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATbTTSOe/yOyVhhEJAQqXQA//Xuc7ubbrmPvm5ypBcwJOme5f2ak6vbe0
7pHxbyZMwckBAV8t8md5Yk+srtpG30TALuR3BojKzq6n/h9omi26bL//GbY+m0lz
7kyRQdezyQCDY6vUNIcRyonNBlEUrP8e9rmRrJP4yMcQiMQL8oJhUMHMbMxsfiCO
cEYZ6V0wY8j6YnCih0SUA6e3B26SdAMhIOHxwj2tQuFvh6gRbstbliQLK0M5kiKp
DKni0d3RiX3HEiqrDmuRPxAKIMZm226OTquv0RtQpUkv0KbWxzTUEE2Y178uzfTw
Z3rniN+860xOLEKHoRDlAVsqBFJ5NNspHz02oLOZiPK3BwcX5EtFRGQCc4SM5XFH
8E0UvxWOxZMDXJHvRjqkAzu1uyAMc8sPzIlq9KgnIwf31uBTaLVW9YY6i8cNsGYb
idq/Ck7rWIG+j2P5/aN/Enlzew80+M8+Gu6F2+A7XjI3DSjSZ298vwFJotgXWTGP
5pAyAnuqOaQey/FAb0GooMAmBDG/x31+Ufli0feQ1mp+TDHx4p/WJawroZAIU1dd
cBvXcgbNYzSo4N4Kez06jqUishl3DvZd12DLbSM0OI07XcewOSIPlNVstk7j06ZV
zrtpUXo+rNpLRMeYhWw79VdI/rhjxm7OI82D6n6JtWsevM3gQ5Z//NzHPOQpw8P+
xiNJk9qfOcc=
=8mSU
-----END PGP SIGNATURE-----

--=-I4UL/mmwDmMfcptt7xKC--
