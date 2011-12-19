Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1LSN0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:26:43 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:35230 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006Ab1LSN0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:26:39 -0500
Date: Mon, 19 Dec 2011 15:26:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        heikki.krogerus@linux.intel.com
Subject: Re: linux-next: Tree for Dec 16 (usb/gadget/langwell)
Message-ID: <20111219132623.GD3146@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111216170042.650147ec79e792dce950f6e3@canb.auug.org.au>
 <4EEB98E0.8080002@xenotime.net>
 <20111216223505.GA14030@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Q7FmPuhIbtiu4EM"
Content-Disposition: inline
In-Reply-To: <20111216223505.GA14030@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Q7FmPuhIbtiu4EM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Dec 17, 2011 at 12:35:06AM +0200, Felipe Balbi wrote:
> On Fri, Dec 16, 2011 at 11:15:44AM -0800, Randy Dunlap wrote:
> > On 12/15/2011 10:00 PM, Stephen Rothwell wrote:
> > > Hi all,
> > >=20
> > > Changes since 20111215:
> >=20
> >=20
> > (not new today; I saw this last week but apparently did not
> > get around to reporting it)
> >=20
> >=20
> > drivers/usb/gadget/langwell_udc.c: In function 'handle_setup_packet':
> > drivers/usb/gadget/langwell_udc.c:2321:19: error: 'struct langwell_otg'=
 has no member named 'otg'
> > drivers/usb/gadget/langwell_udc.c:2322:15: error: 'struct langwell_otg'=
 has no member named 'hsm'
> > drivers/usb/gadget/langwell_udc.c: In function 'handle_usb_reset':
> > drivers/usb/gadget/langwell_udc.c:2757:16: error: 'struct langwell_otg'=
 has no member named 'otg'
> > drivers/usb/gadget/langwell_udc.c:2758:12: error: 'struct langwell_otg'=
 has no member named 'hsm'
> > drivers/usb/gadget/langwell_udc.c: In function 'handle_bus_suspend':
> > drivers/usb/gadget/langwell_udc.c:2774:15: error: 'struct langwell_otg'=
 has no member named 'otg'
> > drivers/usb/gadget/langwell_udc.c:2775:16: error: 'struct langwell_otg'=
 has no member named 'hsm'
> > drivers/usb/gadget/langwell_udc.c:2776:13: error: 'struct langwell_otg'=
 has no member named 'hsm'
> > drivers/usb/gadget/langwell_udc.c:2779:5: error: implicit declaration o=
f function 'langwell_update_transceiver'
> > drivers/usb/gadget/langwell_udc.c:2783:12: error: 'struct langwell_otg'=
 has no member named 'hsm'
> > drivers/usb/gadget/langwell_udc.c:2785:17: error: 'struct langwell_otg'=
 has no member named 'hsm'
> > drivers/usb/gadget/langwell_udc.c:2786:13: error: 'struct langwell_otg'=
 has no member named 'hsm'
> > drivers/usb/gadget/langwell_udc.c: In function 'handle_bus_resume':
> > drivers/usb/gadget/langwell_udc.c:2827:15: error: 'struct langwell_otg'=
 has no member named 'otg'
> > drivers/usb/gadget/langwell_udc.c:2828:12: error: 'struct langwell_otg'=
 has no member named 'hsm'
> > drivers/usb/gadget/langwell_udc.c: In function 'langwell_udc_probe':
> > drivers/usb/gadget/langwell_udc.c:3119:2: error: implicit declaration o=
f function 'otg_to_langwell'
> > drivers/usb/gadget/langwell_udc.c:3119:12: warning: assignment makes po=
inter from integer without a cast
> > drivers/usb/gadget/langwell_udc.c:3120:18: error: 'struct langwell_otg'=
 has no member named 'regs'
> > drivers/usb/gadget/langwell_udc.c: In function 'init':
> > drivers/usb/gadget/langwell_udc.c:3529:2: error: implicit declaration o=
f function 'langwell_register_peripheral'
> > drivers/usb/gadget/langwell_udc.c: In function 'cleanup':
> > drivers/usb/gadget/langwell_udc.c:3540:2: error: implicit declaration o=
f function 'langwell_unregister_peripheral'
> > drivers/usb/gadget/langwell_udc.c:3540:2: warning: 'return' with a valu=
e, in function returning void
>=20
> aparently this has never been compiled with CONFIG_USB_LANGWELL_OTG
> before.
>=20
> Xiaochen, please fix that ASAP. Now that I look at it, that driver
> should have been on staging. It's pretty messed up. Isn't it one of
> those devices which is based on ChipIdea's core ? I wonder when that
> consolidation work will get done.
>=20
> I expect to see this fixed still on 3.2 series. Also needs a backport to
> fix older stable kernels. v2.6.31 is the first kernel with that driver
> available.
>=20
> Thanks for the report Randy

Xiaochen Shen <xiaochen.shen@intel.com> doesn't exist anymore. Maybe
Alex and/or Heikki can take a look at it

--=20
balbi

--/Q7FmPuhIbtiu4EM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO7zt/AAoJEIaOsuA1yqREOJQP/15jIpWC7s9Iu0gQUoFAb4U2
fxWZaqQidNAky1cJGckKHPU8qnwlfawhp9bXR32nUQO/jxW/npYwrw9OafMTc3Eq
E2+nzCDsDR/WA4C+KTbMQCLkleLQJsIsglSGWd3k1eJKaxBtCXUPYlnN+rr0x/Mm
nWA5HYASPgVCF0QuLEPm3DmTDrUMCnv2n1qubjh7C74SQOY0bY9ifoLehB84doWa
NZYpoGtBzsK4UTk8Ss+jwA+B76o2nmrnjxneoZb71fMqX4u9o9ib62dRAF4/5KAl
4LuRF8y3t4qeuKEPdLRH62YtueulNN372TOzZJm3UjVxEIxgqIddRkFjRNbluvt4
DRE8hvSs0tqn3yF0QtMKD10eVc+UMl+zzsMQt2blMIrLGmdk0GCnqeI48ak+TjcD
r0zpW5ehjIrhn+ynCs4iwmASYXECvPokgHRuC+Mg0GTTByA2S9koWXbFX/2/04wz
PJAAWVj3ve551x2OdQ2R4DTiUt+vbopZvfiT7DswO3BlclQuthlxOJsNeGh9rVRS
32aeCViLjhMuymFcPCSK2brVKxrxlMPoQMtImtHTFeYrZ+9sCwonk5dBXhpAPGGb
4ajTm7JtJdjTWq7krj2TqDFFwPZUZ4h4RuDQ3OttZWD+mupFFTmO1X/lGW/4yZxj
ATk9V+U3//O6YyW6+kSQ
=fCSy
-----END PGP SIGNATURE-----

--/Q7FmPuhIbtiu4EM--
