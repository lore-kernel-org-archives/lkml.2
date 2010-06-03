Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918Ab0FCKna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:43:30 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34868 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933837Ab0FCKn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:43:28 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Oliver Neukum <oneukum@suse.de>
Subject: Re: [linux-pm] [regression] Please add bug 15788 and 15969, usb sound / radeon kms broken after snapshot cycle
Date: Thu, 3 Jun 2010 12:42:46 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33.2-tp42-toi-3.1-lowmem-free-991-992-04964-gf00c7ec-dirty; KDE/4.4.3; i686; ; )
Cc: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
References: <201005312215.17793.Martin@lichtvoll.de> <201006011002.59191.oneukum@suse.de> (sfid-20100601_212614_090179_B3E275A8)
In-Reply-To: <201006011002.59191.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3450944.LDfSZctE7r";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201006031243.16703.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3450944.LDfSZctE7r
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am Dienstag 01 Juni 2010 schrieb Oliver Neukum:
> Am Montag, 31. Mai 2010 22:15:04 schrieb Martin Steigerwald:
> > Hi Rafael,
> >=20
> > please add
> >=20
> > Bug 15788 -  external usb sound card doesn't work after resume
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D15788
>=20
> Does it show up in /proc/asound/cards ?

Currently I have 2.6.33.1 installed again, since even the work-around to=20
unload and reload the usb audio sound module did not work. And on the=20
other machine, my ThinkPad T42, I had two hard freezes, but these might or=
=20
might not be related to Radeon KMS stuff. Not yet reported, as I did not=20
yet take time for it and I do not have many details or any idea on what=20
circumstances these freezes happened.

It was all too much for me and I decided to go back to a kernel that works=
=20
for me.

I had it in lsusb at least.

I hope to have time and energy for further testing soon, but right now=20
other things are more important to me.

I did one thing tough: I asked your question in the bug report, since=20
there are other reporters that might easy take time for this. When you are=
=20
interested in the outcome, please add your Cc to the bug report.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart3450944.LDfSZctE7r
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkwHhycACgkQmRvqrKWZhMcQawCgpJsNTwsZgty5WDsXC8/OnDZl
TRsAn0Jbo7iZk5w5sdnOaO9Cv/NI5nYD
=6Xlk
-----END PGP SIGNATURE-----

--nextPart3450944.LDfSZctE7r--
