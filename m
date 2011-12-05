Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1LEJLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:11:17 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:44530 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876Ab1LEJLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:11:14 -0500
Date: Mon, 5 Dec 2011 11:11:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: balbi@ti.com, Shimrit Malichi <smalichi@codeaurora.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, target-devel@vger.kernel.org
Subject: Re: [RFC] UASP on target
Message-ID: <20111205091109.GG9900@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323028390-12846-1-git-send-email-smalichi@codeaurora.org>
 <20111205082047.GA2423@linutronix.de>
 <20111205082326.GA2734@linutronix.de>
 <20111205083946.GE9900@legolas.emea.dhcp.ti.com>
 <4EDC86F1.2070301@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xeD/fx0+7k8I/QN"
Content-Disposition: inline
In-Reply-To: <4EDC86F1.2070301@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2xeD/fx0+7k8I/QN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2011 at 09:55:13AM +0100, Sebastian Andrzej Siewior wrote:
> On 12/05/2011 09:39 AM, Felipe Balbi wrote:
> >Hi,
> Hi,
>=20
> >On Mon, Dec 05, 2011 at 09:23:26AM +0100, Sebastian Andrzej Siewior wrot=
e:
> >>* Sebastian Andrzej Siewior | 2011-12-05 09:20:47 [+0100]:
> >>
> >>>* Shimrit Malichi | 2011-12-04 21:53:09 [+0200]:
> >>>
> >>>>This patch implements the infrastructure for the UAS gadget driver.
> >>>>The UAS gadget driver registers as a second configuration of the MS
> >>>>gadet driver.
> >>>hch said to use target framework and you haven't done so. This is what=
 I
> >>>have so far. It is not yet complete. What I need to do is:
> >>>- wire up command processing (currently here)
> >>>- wire up data processing
> >>>- check it works =3D>  post v1
> >>>- wire up command tagging =3D>  v2
> >>>- remove hard codings and fix whatever people complained about.
> >
> >This is much better, indeed, but the way it is now, it's only usable by
> >the gadget framework because you have put the function driver on the
> >transport layer. I wonder if there wouldn't be a simple way to split the
> >"SCSI Over USB" part in a more generic way which could be shared between
> >gadget side UASP and host side UASP drivers ?!? Maybe ?!?
> >
> >The drivers/target/uasp_*.c would really be just a transport layer and
> >gadget/host drivers would make calls to that "library" ? Something like
> >that ??
>=20
> There is very little code that is not host specific. For instance
> uas_alloc_cmd_urb() is something that could be used on both side but
> the host is boxing the command and I need to unbox it. So I don't see
> how I could share things except for the defines.
> Most of the things are usb specific. So UAS gets the commands from the
> scsi framework, puts the usb layer around it and sends them.

k, fair enough ;-) Just thought there'd be a better way to share this
code with host side implementation. Nevermind then

--=20
balbi

--2xeD/fx0+7k8I/QN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3IqtAAoJEIaOsuA1yqRE8qYP/08S7JQLJi9A/4LzQjEFsyw4
FRru6g/rtV2kBOW54L1cGZ2EiLS0V4Q3mrzpdpi/UdlxFsmwYhMxBtdxqqdQI6cl
5CCq5MC6wmpNt/bQqAZDjFH4i5tTDcqnoxVT6vxwT/4Y83f0a7gOd0jDGcS0LIJP
1huds3lU2GezFYeWWrU0ifZlZVeCxcV27VCqp+HX8OMCiN33xcVArEj23vmkhVAO
Dp5e8MAqdU/oSLkGdvQ8iLn2vBLi1RmCbHdmzRBFLYJL/Cx2zR6DwUbK9jKDWqBH
910Ef2UxZsN9ZebTyuTz8daXurc5SuSQZEvGcqBme8QabOpgHRYy/aIiRavz3SM1
jc7+4oci/JyfOxGk3rpDJvTe/XNxRU9BxiSyukjQa43rpUo4yNDXb3FJAY1R+4Tc
ngC5lG4cX4OrenFyb6sYl+yqVtBfKrm799nw3W45af+U83pmCrhG/fz2koX4X7JK
mHceOCI8jgMIgpmndcVHZ9X+yBLcNVWTCvJzPRwbpDaWHGRnRuHQWjva0dOAB6UB
TBgQwAWaabVyxIWsdTHi9jqXiJfTt6TAOiaVmSSxrvFJVFulITVhzI/FtdBVyKMF
zeCJRNKuCDQkyTuZyf+e7fW8x2AQ6rPzGf03k+sVQeGEaIrs5UHnubF8J/22i8+q
WTgZWdn6BrOUpZcjLWHi
=R3uG
-----END PGP SIGNATURE-----

--2xeD/fx0+7k8I/QN--
