Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0IJNtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 09:49:09 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51510 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab0IJNtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 09:49:08 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Florian Mickler <florian@mickler.org>
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon DRM KMS related - freezes
Date: Fri, 10 Sep 2010 15:49:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-tp42-toi-3.2-rc1-vmembase-0-05032-g60140c1-dirty; KDE/4.5.1; i686; ; )
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Paolo Ornati <ornati@gmail.com>
References: <201008312153.45792.Martin@lichtvoll.de> <201009091618.51064.Martin@lichtvoll.de> <20100910135511.53c0089a@schatten.dmk.lab> (sfid-20100910_151146_255717_5F7DBF5E)
In-Reply-To: <20100910135511.53c0089a@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5553858.m0dLvm8Tzr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009101549.03845.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5553858.m0dLvm8Tzr
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Freitag 10 September 2010 schrieb Florian Mickler:
> On Thu, 9 Sep 2010 16:18:49 +0200
>=20
> Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Yes, I am aware that it may not be a Ext4 problem at all. Thus I said
> > Ext4 / readahead related (!) backtrace (! not bug) cause that was
> > all I could see on the screen. How else should I have described that
> > backtrace when I can't speculate on what I can not see?
>=20
> I think, it is no big thing. The trick is probably to say nothing at
> all about the cause, when it is not clear. It's a mind thing. As soon
> as the association is brought up, everybody thinks along those lines.=20
> :)
>=20
> If you leave out the "ext4/readahead related", then people will still
> know that it might be ext4 readahead related because you posted the
> backtrace, but they will not have their mind turned to that. Instead
> they will think: oh a backtrace... there were some people shouting
> about backtraces in my area, let's see if it is realted.

OTOH I thought when I put in some keywords from the backtrace in my query=20
it might get the attention of the right people. When I just say unknown=20
backtrace, then I am adressing no one.

> But of course, sometimes putting blame somewhere also does help getting
> attention. After all "CORRUPTION IN FILESYSTEM XYZ" sticks out more
> than "partial trace of a thing i don't know anything at all".

I wouldn't do that for sensational purposes.

Maybe next time: "Fails to boot with partially shown backtrace, with some=20
ext4 / readahead function calls inside it"? Or even more general some I/O=20
/ filesystem related functions?

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart5553858.m0dLvm8Tzr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyKN08ACgkQmRvqrKWZhMfo1ACfQINZ5xudRNzlYYARA62ltokz
3VMAn3fbB/OjELKk90/MbeupTxXo+xIE
=Uyga
-----END PGP SIGNATURE-----

--nextPart5553858.m0dLvm8Tzr--
