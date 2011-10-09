Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab1JIUMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 16:12:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27770 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1JIUMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 16:12:36 -0400
From: Frank Mehnert <frank.mehnert@oracle.com>
Organization: Oracle Corporation
To: Dave Jones <davej@redhat.com>
Subject: Re: RFC: virtualbox tainting.
Date: Sun, 9 Oct 2011 22:12:19 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.4; KDE/4.6.5; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Hall <andy.hall@oracle.com>
References: <20111006190526.GA13883@redhat.com> <201110071640.53827.frank.mehnert@oracle.com> <20111007151003.GA26358@redhat.com>
In-Reply-To: <20111007151003.GA26358@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3332744.PPkJQdSDnU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201110092212.20170.frank.mehnert@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E92002F.0022:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3332744.PPkJQdSDnU
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Friday 07 October 2011 17:10:04 Dave Jones wrote:
> On Fri, Oct 07, 2011 at 04:40:53PM +0200, Frank Mehnert wrote:
>  > I can understand that you would rather ignore bug reports from external
>  > kernel modules. On the other hand I don't like the TAINT_CRAP flag as
>  > you can probably imagine.
>  >=20
>  > Why not just mark external modules like Bastian Blank suggested? I can
>  > assure that we will not try circumvent a TAINT_OOT_MODULE flag.
>=20
> Sure. The exact mechanism used doesn't matter to me.
>=20
>  > Please also note that we always have good relations to the open source
>  > community so feel free to point me an archive where all these kernel
>  > panic reports arrive which you've got.
>=20
> Search through the fedora kernel bugs at bugzilla.redhat.com for 'vboxdrv'
> or 'virtual box' (note to search for closed bugs as well as open ones).

I will have a closer look on this list but at a first glance I saw a
lot of bugs containing a kernel log where the vboxdrv module was loaded
but the problem was clearly not related to VirtualBox. With a normal
installation, the vboxdrv module is loaded during startup of the host
but stays inactive as long as no VM is started.

It would make our life easier if we could have a list with bugs where you
guys have a comprehensible assumption that a bug is clearly related to
VirtualBox.

>  > We fixed some bugs in our kernel
>  > modules in the past and it is even possible that some of the current
>  > bug reports are from older versions of VirtualBox which might have been
>  > fixed in the meantime.
>  >=20
>  > And of course, helpful and constructive critism is always appreciated.
>=20
> If you'd like to be cc'd on those reports, I can add you to the bugs
> when we go through them if you create a bugzilla account.

Thanks, I would indeed appreciate that. I have already a Redhat bugtracker
account, same E-mail address as this one.

Kind regards,

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert
Senior Manager Software Development Desktop Virtualization, VirtualBox
ORACLE Deutschland B.V. & Co. KG | Werkstr. 24 | 71384 Weinstadt, Germany

Hauptverwaltung: Riesstr. 25, D-80992 M=FCnchen
Registergericht: Amtsgericht M=FCnchen, HRA 95603

Komplement=E4rin: ORACLE Deutschland Verwaltung B.V.
Hertogswetering 163/167, 3543 AS Utrecht, Niederlande
Handelsregister der Handelskammer Midden-Niederlande, Nr. 30143697
Gesch=E4ftsf=FChrer: J=FCrgen Kunz, Marcel van de Molen, Alexander van der =
Ven

--nextPart3332744.PPkJQdSDnU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk6SACQACgkQ6z8pigLf3EeCdACdHid015IEsSsKVpEX2dqBR4B2
i6kAoJaKtvvbPbUokNWNLAEEa6wElf8z
=9XvA
-----END PGP SIGNATURE-----

--nextPart3332744.PPkJQdSDnU--
