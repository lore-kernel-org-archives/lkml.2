Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2IISSD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 14:18:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49045 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205Ab2IISSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 14:18:00 -0400
Message-ID: <1347214667.7709.58.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [Squashfs-devel] PROBLEM: mount empty SquashFS
From: Ben Hutchings <ben@decadent.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
        Cyril Strejc <strejc@unicontrols.cz>, phillip@squashfs.org.uk,
        squashfs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Sun, 09 Sep 2012 19:17:47 +0100
In-Reply-To: <CAMuHMdXXP=iF8qiBydYGgaKUpTR=88Y7uUTf9uquA7cbwMeo7w@mail.gmail.com>
References: <5017A064.1030605@unicontrols.cz>
	 <5018AFA8.8070709@lougher.demon.co.uk>
	 <CAMuHMdXXP=iF8qiBydYGgaKUpTR=88Y7uUTf9uquA7cbwMeo7w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8kWlT03S5eDyPtfMlKDE"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8kWlT03S5eDyPtfMlKDE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-09-04 at 20:52 +0200, Geert Uytterhoeven wrote:
> Hi Phillip,
>=20
> On Wed, Aug 1, 2012 at 6:25 AM, Phillip Lougher
> <phillip@lougher.demon.co.uk> wrote:
[...]
> > I discovered the sanity checks mistakenly flagged empty filesystems
> > as invalid in January, and added a fix to the mainline kernel, FYI
> > the commit is here:
> >
> > http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3Dcc37f75a9ffbbfcb1c3297534f293c8284e3c5a6
[...]
> I can easily imagine a system that has an optional filesystem mounted,
> which may be empty. For such a system, it's a regression.
>=20
> So I think this warrants application to the stable 3.0, 3.1, and 3.2 bran=
ches.
> Commit cc37f75a9ffbbfcb1c3297534f293c8284e3c5a6 ("Squashfs: fix
> mount time sanity check for corrupted superblock") seems to cherry-pick j=
ust
> fine on v3.0.42, v3.1.10, and v3.2.28.
[...]

I've queued this up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

--=-8kWlT03S5eDyPtfMlKDE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUEzdS+e/yOyVhhEJAQodxRAAp124lYof5+6YoPKHTPlla2BpU4GedH+n
N9fra4vLctljfoW0oCp3VfjXuuFTL8g91xhGpstie8wshjH2w6Z3NuUY6JKaa2vl
pyi4WxL2PicqAXcJw5Qqd/iJbQd/d8o01TZj9wYx+K+2E+YIGKMZlzxVhuV2bV9d
DDMsOvn+iDPe7BIOtODUCJg4U36vsPBtfwNl7lMhW5TLnh6izmWD+kFCnNEVNt2L
I8JLa8guywf3hESAEajkYwPa9negUnnxZRQaUOhrsRrg0F2iH6TwPn6VkwdXlJS3
+V7zqMBPF1LGczr+G2BEG9Zjgx8gbgVuobK0i85U8YfzmtfXBIjygRrvExXjBfbN
NKAFrvZoPf3OpZDsfbHlVy50dFoSb1jP8z1orR9JmkYmDF3U6Vbjis+st0X2Prh9
bHjtNceV48fHBF7cCwYyP5FncmiT6kYaUNvWzeUdb/4g/xmR8KbTkXy2ntEwyJaG
X7/gV7CJJe/cwNT3TE8Qp6RbUbV8VY5Wq4DO3HiqyCioAf3hsjx7F1hHpSAhKw7o
UvNiYz5TfquogVlyuCFKNuWh14aSpDo8gPmaFxT/8cxKMAEVHT/5RvnSYhcDF2em
FkrksTj3fWYXKIMxk/Ms9FuYt2Rv9wUDrH90NjQiqrqUr6LUXb+FAila01n3burO
DgIK+P2jPVA=
=ftTT
-----END PGP SIGNATURE-----

--=-8kWlT03S5eDyPtfMlKDE--
