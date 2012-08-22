Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2HVLTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:19:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44747 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116Ab2HVLTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:19:16 -0400
Date: Wed, 22 Aug 2012 12:19:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120822111913.GG7995@opensource.wolfsonmicro.com>
References: <20120820162923.GF26991@opensource.wolfsonmicro.com>
 <20120820164949.GB22749@gmail.com>
 <20120820175155.GH26991@opensource.wolfsonmicro.com>
 <20120821085618.GA26899@gmail.com>
 <20120821095026.GU26991@opensource.wolfsonmicro.com>
 <20120821105413.GD26899@gmail.com>
 <20120821110329.GA7995@opensource.wolfsonmicro.com>
 <20120821120243.GF26899@gmail.com>
 <20120821165207.GX7995@opensource.wolfsonmicro.com>
 <20120822081746.GA4089@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="czsrKamv0OtYjSMr"
Content-Disposition: inline
In-Reply-To: <20120822081746.GA4089@gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--czsrKamv0OtYjSMr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 22, 2012 at 09:17:50AM +0100, Lee Jones wrote:

> I was saying that in order for the MFD core to carry out the hwirq->virq
> conversion, it needed to obtain the irqdomain pointer pertaining to the
> provided hwirq. The only helper function the irqdomain subsystem provides
> requires a device node pointer to be passed as an argument, hence the
> mention of 'irq_find_host(struct device_node *np)'. Then the Device Tree
> is traversed until a specified 'interrupt-controller' is stumbled upon
> or is pointed to by the 'interrupt-parent' property. Hence, we have to=20
> find another way to find the irqdomain pointers for non-DT based MFDs. To
> which we now have a solution.

Oh, right.  Yes, there's no way to get an irqdomain if you don't already
have it or something which has a direct mapping to one like an irqdomain.

> > I made the suggestion then later on realised that this was actively
> > going to break things I care about so I actually need it fixing.

> I'm a little taken aback and annoyed by this. In a previous email thread
> you categorically requested that I discuss some of the important changes
> with maintainers and people in-the-know prior to actually writing any
> code.

No, that's not something I've ever said to do.

I *have* asked you to communicate more clearly about what you're doing
but that doesn't mean to stop sending code, it means to have clearer
words around what you're sending.  The really bad pattern here is that
you're frequently working around issues in your drivers with changes in
the subsystem without mentioning that the driver issues even exist -
this makes it much harder understand what you are trying to achieve,
especially when there is a problem with your subsystem changes and/or
the urgency you're attaching to them.

>       I was obviously actively working on, had put time into, and was in
> the mist of discussing this with you. Then you just go ahead and code it
> (the easy part) yourself, essentially wasting my time. Surely there's
> some kind of etiquette surrounding such things?

To be honest in this case I had expected to send the patch out much
sooner than I did - several priority interrupts stopped me testing it.
Like I say I realised that I really needed a fix and it seemed like the
quickest way to accomplish that was to just send the code.

--czsrKamv0OtYjSMr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNMAaAAoJEFJkBDiqVpZ4aU4QAJokHqgJZud9mlB/NEhcTdXy
g0Q2n+SNmCpHC9aJv9jhV1ywsrzSVVCLfI0KmLmQJD26CGt/0GEQFxHQ9WJ4cTuA
r0CCpbVPFZ4+6iHwRdIgnImeMPqMVR+AefH1gaRrEYIQY7244rk4m0agQ2uPCPh7
Dp344nanXxrn0C/dMp8U6FNRKvqQvwkWFPlvwUadzD9B00wgkCLTndAsLswMpBMC
NHFUO78Z8CtvkYYiwb1rh7G0sL5c/riH9X9+2jaZ8BI0ctx8UjIndDTdAM+ZM3bJ
uHTMFRFseHSNUsXUawK9N31ijKXJUunXRT27B5DW8Y49vQeEUicUPMEBOs0fJ0YQ
P75nTyXDDKeIX4FWUvAGoDUaeePTSC6GRB4pcZTel2AVlBzzEIH0vnirLRdxam2u
DE4zCTGHL8HCi+BTUn/Ot+8BuiGTfMf2cwkp7qUIiRnmOimuMdQigq8M+UUZxMRR
eSoB2v3x6mNRdAhjtqt/hwhAI5+QCPuUkt+w+iRNbwHKFmq8B+ClTL+URjMebp/q
6LE3wcUBv9n8on4REejmAEopayqOT5M81bWY+2mlkV4131mTEF7L184bTROOVITZ
N3qAkN7KRaH3MZds7MDy0p6Phh4AxbSEu131OUfghitnCGkOZgIq3rE+AF+PB/p9
C83kpkvnNAWSlhwxVUhm
=VdG1
-----END PGP SIGNATURE-----

--czsrKamv0OtYjSMr--
