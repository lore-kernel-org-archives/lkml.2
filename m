Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab0IYPE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 11:04:58 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53539 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab0IYPE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 11:04:57 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Nigel's current for-rafael queue
Date: Sat, 25 Sep 2010 17:04:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.5-tp42-vmembase-0-pm-avoid-oom-dirty; KDE/4.5.1; i686; ; )
Cc: Nigel Cunningham <nigel@tuxonice.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net> (sfid-20100925_095715_038909_A9814B83)
In-Reply-To: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4127678.rHa97IMe2R";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009251704.50186.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4127678.rHa97IMe2R
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Samstag 25 September 2010 schrieb Nigel Cunningham:
> Hi Rafael.

Hi Nigel,
=20
> Please find attached a slightly updated version of the patchset I sent
> a few months ago. The main change is that I've prepended and additional
> patch which lets the user see the speed at which the image is being
> read and written. This is accomplished by recording the MB/s in a
> single byte in the image header, and using a couple of __nosavedata
> variables to get the data back through the atomic restore. I realise
> the char limits us to 255MB/s at the moment. In future patches, I
> intend to address this by storing the data in a 'proper' image header
> (it's a real problem - TuxOnIce reads and writes on the same set up at
> speeds around 250MB/s).

I like to help by testing these. Is it sufficient to check out your latest=
=20
tuxonice tree, checkout branch for-rafael and switch the hibernate script=20
to TryMethod disk.conf?

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart4127678.rHa97IMe2R
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyeD4oACgkQmRvqrKWZhMcgLwCeM/lEmXqxTzd9HDXzA9TKGpoK
sOEAmwV6unoKnH80BkrtAMhQfLdJcIwD
=ndGy
-----END PGP SIGNATURE-----

--nextPart4127678.rHa97IMe2R--
