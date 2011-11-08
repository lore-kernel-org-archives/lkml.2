Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab1KHTCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:02:09 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:59633 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933049Ab1KHTCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:02:07 -0500
Date: Tue, 8 Nov 2011 21:02:02 +0200
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        rmallon@gmail.com, Nikolaus Voss <n.voss@weinmann.de>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, khali@linux-fr.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
Message-ID: <20111108190200.GC24399@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1320753142.git.n.voss@weinmann.de>
 <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de>
 <20111108144115.GH20728@legolas.emea.dhcp.ti.com>
 <4EB9477E.8070002@atmel.com>
 <20111108152343.GJ20728@legolas.emea.dhcp.ti.com>
 <20111108182955.GH12913@n2100.arm.linux.org.uk>
 <20111108184447.GB24399@legolas.emea.dhcp.ti.com>
 <20111108185525.GI12913@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
Content-Disposition: inline
In-Reply-To: <20111108185525.GI12913@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 08, 2011 at 06:55:25PM +0000, Russell King - ARM Linux wrote:
> > so ? Instead of saying this to me, you should contact the
> > authors/maintainers of those drivers and ask them to clean that up.
>=20
> Oh for god sake, I was just asking you to clarify your statement in
> light of what is currently being done.
>=20
> Now, let me set something straight.  I've been saying that machine_is_xxx=
()
> should not be used in drivers.  That's a platform thing and platform
> specifics should not be in drivers - it should be passed in via DT or
> platform data.  That's enforced by the way DT works (Grant's decision
> not mine) - with DT you don't have any kind of testable machine ID for
> machine_is_xxx() to use.
>=20
> I've never said that cpu_is_xxx() should not - that's something *other*
> people are saying (and quite rightly so) because if we're going to start
> sharing drivers between different SoCs (or even architectures - eg, PXA
> IP appearing on x86) then it doesn't make sense for the type of SoC to
> be tested.  It makes more sense for the revision of the IP implementation
> to be checked IFF such information is available.  If not, some other way
> of controlling the 'features' needs to be sought.
>=20
> As far as the use of asm/*.h includes, I've NEVER made any statement
> about the use of those in drivers.  In fact, I don't see any reason to
> avoid them _provided_ they're standard cross-arch includes.
>=20
> As for mach/*.h includes, I don't think that I've made any statement
> about those either, but at this point - given that we're working towards
> a single zImage on ARM - it is _sensible_ to avoid such includes in
> drivers.
>=20
> So, I think your reaction to my statement is way off mark, and you're
> attributing statements (that it seems you personally don't agree with)
> to me.

If I did, then it's really my fault. But I _do_ remember you complaining
about uses of <asm/gpio.h> instead of <linux/gpio.h>, for example.

Now, all the other topics I agree and, in fact, have been pushing for
that as I can. Specially with regards to IP cores being shared among
several architectures (see drivers/usb/dwc3 where I have a core driver
shared between ARM and PCI/x86).

--=20
balbi

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuXynAAoJEIaOsuA1yqREQmQP/jbGMYTk0uFegTbhIe5fiW89
4S/EBr9eoxvv6hLxNoihcn9u177/+KFu1whsXkZq1BqDHrKsNlYbnyJH77H0Oqzg
wMk5yHDfNdjRZfcAGHEcCcWnNHARQxa8pms0P6ZAbs/Zq9fHWsbg6fYOwhDO0+c/
kWNAmppvLorp62R2r2Tyqt/TtjUnG0BxYlmF7IBBoKDQTERdN8wXKryo3SisUMIK
D9KPJKoDXspoP5G2V0Z4+Y1EjYK7AK+64ALy56bH28cg8eVOqI79ZnU3lZx2oXbc
9cJ4dgDCfupVhy3td/q0k6A5+go7Vxm1HNcbRvuKWuC/Y0H+0UnBK/FJj0gC6U6D
FDzKuq5H6gKhq3tuWEqolT59EtjSQxN0v0gS8NOsld3RqMwQwV0ih98q0vovq0hu
YHfVoRDiQMZhV9Tlz3DNDdme9Fv1AHErbUF159PzVXwjqzxwJDI4vj6abDF4owJv
2OQSfnXCh5Vk0fdGwbhkue0fWlL1qaSSVlrscz622Iy4bg3HhjQIMmXxVPgVN/8l
Ojo2KJ00xCCS0cNI/4xiQlsZkeE0WSONy/PIrae6O5BVmyTVhneeIEFH/jznLpKk
+gI0DMflYiGZusZTFb7zeCFeCYlWjlxegqWQpAjKS2yFaRI7m4tZu6UfPv/xpLbi
tz175ZoL7KSeqL7KoL0K
=iJrT
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
