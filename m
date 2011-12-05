Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab1LEMOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:14:24 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:51817 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932103Ab1LEMOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:14:22 -0500
Date: Mon, 5 Dec 2011 14:14:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Shimrit Malichi <smalichi@codeaurora.org>
Cc: balbi@ti.com, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        "USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, target-devel@vger.kernel.org
Subject: Re: [RFC] UASP on target
Message-ID: <20111205121416.GM9900@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323028390-12846-1-git-send-email-smalichi@codeaurora.org>
 <20111205082047.GA2423@linutronix.de>
 <20111205082326.GA2734@linutronix.de>
 <20111205083946.GE9900@legolas.emea.dhcp.ti.com>
 <4EDC86F1.2070301@linutronix.de>
 <20111205091109.GG9900@legolas.emea.dhcp.ti.com>
 <9a0cf9e5dd108a8d17748c67afe45f9d.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sj9mcRtP+pTWLOo"
Content-Disposition: inline
In-Reply-To: <9a0cf9e5dd108a8d17748c67afe45f9d.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6sj9mcRtP+pTWLOo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2011 at 04:10:50AM -0800, Shimrit Malichi wrote:
>=20
> > On Mon, Dec 05, 2011 at 09:55:13AM +0100, Sebastian Andrzej Siewior wro=
te:
> >> On 12/05/2011 09:39 AM, Felipe Balbi wrote:
> >> >Hi,
> >> Hi,
> >>
> >> >On Mon, Dec 05, 2011 at 09:23:26AM +0100, Sebastian Andrzej Siewior
> >> wrote:
> >> >>* Sebastian Andrzej Siewior | 2011-12-05 09:20:47 [+0100]:
> >> >>
> >> >>>* Shimrit Malichi | 2011-12-04 21:53:09 [+0200]:
> >> >>>
> >> >>>>This patch implements the infrastructure for the UAS gadget driver.
> >> >>>>The UAS gadget driver registers as a second configuration of the MS
> >> >>>>gadet driver.
> >> >>>hch said to use target framework and you haven't done so. This is
> >> what I
> >> >>>have so far. It is not yet complete. What I need to do is:
> >> >>>- wire up command processing (currently here)
> >> >>>- wire up data processing
> >> >>>- check it works =3D>  post v1
> >> >>>- wire up command tagging =3D>  v2
> >> >>>- remove hard codings and fix whatever people complained about.
> >> >
> >> >This is much better, indeed, but the way it is now, it's only usable =
by
> >> >the gadget framework because you have put the function driver on the
> >> >transport layer. I wonder if there wouldn't be a simple way to split
> >> the
> >> >"SCSI Over USB" part in a more generic way which could be shared
> >> between
> >> >gadget side UASP and host side UASP drivers ?!? Maybe ?!?
> >> >
> >> >The drivers/target/uasp_*.c would really be just a transport layer and
> >> >gadget/host drivers would make calls to that "library" ? Something li=
ke
> >> >that ??
> >>
> >> There is very little code that is not host specific. For instance
> >> uas_alloc_cmd_urb() is something that could be used on both side but
> >> the host is boxing the command and I need to unbox it. So I don't see
> >> how I could share things except for the defines.
> >> Most of the things are usb specific. So UAS gets the commands from the
> >> scsi framework, puts the usb layer around it and sends them.
> >
> > k, fair enough ;-) Just thought there'd be a better way to share this
> > code with host side implementation. Nevermind then
> >
> > --
> > balbi
> >
>=20
> Hi guys,
>=20
> Thanks for your quick response.
> We are glad to see that our initial implementation is being used and
> gaining momentum.
>=20
> We  intend to learn and re-implement the UAS protocol using the target
> framework, and continue our work started few months ago.

Sebastian has been doing for the last few days or so, you guys should
join efforts to avoid duplicated work.

> We hope to get your corporation in the future as well.

sorry, but I'm not allowed to you my corporation. Hope my cooperation is
enough :-)

--=20
balbi

--6sj9mcRtP+pTWLOo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3LWYAAoJEIaOsuA1yqREvUQP/3znNWsvM0cTHz9HDzzHD6+c
ShCitzRDWVCpZwrJpBdsQnPeW4kL4mGtizo1HqFSPVhElrywkNlhpX/ZYdRkbvFz
LGAiASrjYZWtN2jHm5Db4Be0WnKsCcJHk573GseE44ybvOwKL855VICTTEJA9OiB
p1g+HfYc8E0m6Zg4dX5i9VXzFiXN2W1zHgJQ88M7mpnnoOQzsVRMJvNbvP3CkAYB
dQVUd3RW7w0jOAPn3JGbBSxzEq2c8sdSBIAbB42oVZvGTlYq2W3r3+yFrPJPSgvQ
qa6jEWznJMt3SHJ6PYa9YvSVxbHwi28pWKZ43PctF7Qb/NuY6p0hNHabqWDG1BtC
/HO3kB7GrmkfjBs6e2vbOIFvs0vH3kPsJ0YdQCmbWrAloehbc4jrnl+OGWYDHL+V
C627ut/Fd+7iD1BRabMBFn1uzMiAQQ/TIAhfOvbCrF+6xPkoIPR25i9Zazf+TSUS
NjUEHqtheS4Wwgf199fWSe57i8l/mymx3dhhU4ZbVQbtoSMiUwnIu+Xnrkntk6gs
CupTUN/xdYpRg7pH4GujYTZmmmRM9dVOc8Pdy9QpHhHte71zZQ3rlI9wuyLoVHqO
sUT4Q8fO57skfBw4ox3voQOSnNbeI2TzgS8IonF4sr/JX0QKTVv1rdQ1EfUkB78p
dzE71YtBaeQX65GjMY+t
=tgEr
-----END PGP SIGNATURE-----

--6sj9mcRtP+pTWLOo--
