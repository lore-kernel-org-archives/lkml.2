Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1KRJSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:18:36 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:46849 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290Ab1KRJRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:17:52 -0500
Date: Fri, 18 Nov 2011 11:17:48 +0200
From: Felipe Balbi <balbi@ti.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: balbi@ti.com, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Kevin Cernekee <cernekee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] ahci: platform support for suspend/resume
Message-ID: <20111118091747.GD9759@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1321475279-29930-1-git-send-email-computersforpeace@gmail.com>
 <20111116203422.GA29581@legolas.emea.dhcp.ti.com>
 <CAN8TOE9T8YJ8Kbz=cuQ_CYPQozxU--yskZuBcXwe_emVVNQqDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fOHHtNG4YXGJ0yqR"
Content-Disposition: inline
In-Reply-To: <CAN8TOE9T8YJ8Kbz=cuQ_CYPQozxU--yskZuBcXwe_emVVNQqDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fOHHtNG4YXGJ0yqR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 17, 2011 at 04:31:32PM -0800, Brian Norris wrote:
> +linux-pm mailing list
>=20
> Hi Felipe,
>=20
> On Wed, Nov 16, 2011 at 12:34 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Wed, Nov 16, 2011 at 12:27:59PM -0800, Brian Norris wrote:
> >> + =A0 =A0 /* Does platform support suspend/resume? */
> >> + =A0 =A0 if (!pdata->suspend || !pdata->resume)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> >
> > should you really prevent suspend is platform doesn't provide
> > ->suspend() ?
>=20
> No, we shouldn't prevent suspend entirely; that would just be my
> accidental side effect.
>=20
> > I mean, we could some platform where all clocks are autogated and
> > there's no need for platform to do anything. Would it be better to only
> > call pdata->suspend if it exists but still let the AHCI-specific part go
> > through ?
>=20
> Perhaps. But would this have any unintended effects on systems that
> don't implement AHCI power management at all? My intention was just to
> provide an 'opt-in' interface for platform developers. I probably got
> this wrong.

I guess you could add a flag for that, but until we know that the AHCI
powermanagement is broken somewhere should we really care ? :-)

--=20
balbi

--fOHHtNG4YXGJ0yqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOxiK7AAoJEIaOsuA1yqREU/EQALUUH2e/7kVn88k+MFSnW6f4
71/RTp+rXa+LROdZF+XQtnguPrhazJ6noX5hMhDRsYOt645QMHU3zzV1PgSeCdNI
Y+QDzmZsPMtYPqiPbmS9Q4r4NwQGAasrxPnW1eDPck0HRbXyi5qz3CTiNksYaZ1+
7eihLXRyxC+2kHBH7cDBLYJ1Q9wrWaK3XC3ctI+541mBib3R/RSma5R8YeeKmWNj
s6unkGZdbQBgHWQ6grew2jFuoL405PCZ/Ong8EXf9A6PBs+hVB/sLRtWSWr3I0Sc
ufJJrR9PV8EDa/rC2h2M+XS1L0viP9xHC7eR/iOrE+jpS2aACCj9QAT2CD+FnN6R
DNO8c5ciTIA6y2JFUnsELGJqTJ0GrkD8GAea4ut0tWzcN++8mhLJyokLitEEPLqF
bnZL0pdvQ8o+MGa/7r1N0y7eT5jInHkIRVJvILxJBeDBCyhmoxkWCANR6vV5fkNC
Tg+FmgWrDPUQLKJavTiEeiB6jlDQxeTuvMbV/4EMWxoOxUhk6nphVKsT00eSH03C
Tr7ER1mCKWNyqhjQJp+NANT0VZpOlP008jvR9UhtD3ddPFGLXjaMvi2gRW93oLVw
+OmdUXG1W4MxDKze4pzhT8pZtS83QdgttZoOfMlc7Rm804pa1uaTrzrlTaO7pWMM
5XUteNkcmemjHRq59adt
=fhKt
-----END PGP SIGNATURE-----

--fOHHtNG4YXGJ0yqR--
