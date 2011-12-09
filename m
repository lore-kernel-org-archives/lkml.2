Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab1LIRQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:16:59 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:37203 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab1LIRQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:16:57 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [uclinux-dist-devel] [PATCH 2/2] serial: bfin-uart: Remove ASYNC_CTS_FLOW flag for hardware automatic CTS.
Date: Fri, 9 Dec 2011 12:17:05 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.0-atsc; KDE/4.6.5; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Sonic Zhang <sonic.adi@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
References: <1323410421-10465-1-git-send-email-sonic.adi@gmail.com> <1323410421-10465-2-git-send-email-sonic.adi@gmail.com> <20111209111205.04780196@pyramind.ukuu.org.uk>
In-Reply-To: <20111209111205.04780196@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7932394.Jhr7JSu9ic";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201112091217.07781.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7932394.Jhr7JSu9ic
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Friday 09 December 2011 06:12:05 Alan Cox wrote:
> > +#ifdef CONFIG_SERIAL_BFIN_CTSRTS
> >=20
> >  			uart->port.flags |=3D ASYNC_CTS_FLOW;
> >=20
> > +#endif
>=20
> As an aside could the cts/hard cts etc be passed as properties to the
> platform device rather than ifdeffed ?

most platforms don't bother with flow control, so we made support in the dr=
iver=20
optional to keep things smaller.
=2Dmike

--nextPart7932394.Jhr7JSu9ic
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJO4kKTAAoJEEFjO5/oN/WBzYUQAMl7PfoQfpgop0CqEqMcFlod
+b3hYpHew2RHmi5eX4QJ/6c4FHJiZdnDm/tFU3Ntm5Jr7KdGwRZpN5OK8b2wkFaq
X2AhEWVUARckcJns0B9w7A9qtVtVbiJ23HIsv9AVBczJu9wxjZgfH1n0a9ppAG5N
5Srp4usVxpOjdiZvqtm2p92vB8Txu4w9+9taCw5Tq/vTAUnylejvJQvn/Omk69m6
cMjNwDu9F8kMIzo1t23Ro9qqt3hKX2yblMdCDtMhkO4dEF18AMMApkoso+4IfxZW
Q6gMYKrDItiMA/Y25N/6PcFYKkVpSR1cBDpAEqoIMVieiwF/62uiNHsyiv3xxRTc
GnoEabH70emJNaMhkZ3Hhlk1Gg20iY7Xy6AVRxvcV029nprQmWgxWS8jpPURTxWF
qCOf+Mds5uEK26Z6ygXsFXtxQSFBA0KfdJu+cRGnO5C9LagUNDUcZ1h0QjsMglWw
DwpZGORsvJ4weC+Sn1I7kvT+f9mAZuO2AOSetoRU6b4438KHFcDvubj0CfnSHDv2
kzNaw/bsIVTusQdZWKUBEtB2WPnXouWd9gSNH0ALKWR0gsoc6sbBOTx+vOrqvwb7
eXkq3RSa0WG0cVvzu6fE/F1sROtJTEn7aXOKkYsKqME8/INs4B/nRcCe1R1HAstZ
vTaH63tyTrSFUR4YBroH
=czfR
-----END PGP SIGNATURE-----

--nextPart7932394.Jhr7JSu9ic--
