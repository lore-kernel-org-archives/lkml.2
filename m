Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2DJUeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:34:16 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:54444 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757221Ab2DJUeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:34:15 -0400
Date: Tue, 10 Apr 2012 13:34:11 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Jiri Slaby <jslaby@suse.cz>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120410133411.52dc52ed@jbarnes-desktop>
In-Reply-To: <20120410203212.GN4115@phenom.ffwll.local>
References: <4F717CE3.4040206@suse.cz>
	<4F717D80.9040207@suse.cz>
	<4F758400.3080907@suse.cz>
	<1333104359_155028@CP5-2952>
	<20120409101119.47e770b2@jbarnes-desktop>
	<4F83F3B5.8080704@suse.cz>
	<20120410092619.26a15165@jbarnes-desktop>
	<4F8477D1.4080102@suse.cz>
	<20120410113448.540e4c1d@jbarnes-desktop>
	<4F848F88.7060009@suse.cz>
	<20120410203212.GN4115@phenom.ffwll.local>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9WyWI2/e0i29p3xOeXAafgF"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9WyWI2/e0i29p3xOeXAafgF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Apr 2012 22:32:12 +0200
Daniel Vetter <daniel@ffwll.ch> wrote:

> On Tue, Apr 10, 2012 at 09:52:40PM +0200, Jiri Slaby wrote:
> > Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> >=20
> > I tried 3.2 and 3.3. Although the spurious interrupts were always
> > there, they occurred with frequency lower by a magnitude (15 vs. 300
> > after X starts). So I bisected that and it lead to a commit which
> > fixes bad tiling for me:
> > http://cgit.freedesktop.org/~ickle/linux-2.6/commit/?h=3Dfor-jiri&id=3D=
79710e6ccabdac80c65cd13b944695ecc3e42a9d
>=20
> Pipelined fencing is pretty much just broken and we'll completely rip it
> out in 3.5. Does this also happen with 3.4-rc2?

Does INTx- stay that way?  Or does it frequently read INTx+ if you
sample it a lot?  If it stays as INTx-, then something other than the
GPU is getting stuck (though it's possible this could be related to
pipelined fencing, if the fences are programmed to point at some funky
memory space).

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/9WyWI2/e0i29p3xOeXAafgF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhJlEAAoJEIEoDkX4Qk9hdIkP+wSN1KZ3zYNAo3bcFzhiVn5U
5WhZaT+I0JLjq3Oyis43gPbcqthopZtOwZ8SzwHQlbiqJOMDplkbfAo85JdoN+GB
jdqWOGuGOCgEgQNikt/OntuQJAvSt41OvaAepIieL8B6iZ+mDCm0Zpj+eQR8dpBw
2r5OBWYv7ReQmZNmoX74+d46AsOfO2CwhmujzT5CHTYfj+DTYBINs1c8JSkV+Mnc
DoGZ9jWgx23YN8wkGPrK6z2udhBlrIeqk29V11nlon25kWFJlETAnt1lHa0QSg9S
8qoSOxc8BrM0yR9QSZJrTEg0MhuX66ruCeuTP3RwjNzw7vyemRrSiCYOBKdonKJm
ms9ThPjlvaunCt88iDR/f5v3mkVUV3coBw9i7L+wXgUVZ5Qio2FO5kxDcEUVZxYc
LFqB4eqBgfJmZ6yY3rVLE6p0SFoLldoIy2tmabKX9QH6fID1F/aKgDTU6nvsRYZs
IwxSabTLJqpXoH7CsVi4a5tXmeMMojUq8esBLVzuj1aiGj/MRlXBDE375IXPve4O
rKdSeZ3LDY3DgkQJCKVMDB2OVzEjwYCiAm65pfIkL6TKOjy6zQHF206yg9wXSFlK
dPpL20v5pI17zTvNNGRsNgurNC0yGEE6xiczadNx05g2uJ37ZIVtJxEicY3WQR2g
ph8OH1QyTO+2VITcueB+
=9EkS
-----END PGP SIGNATURE-----

--Sig_/9WyWI2/e0i29p3xOeXAafgF--
