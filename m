Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab2DVSiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 14:38:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56325 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2DVSiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 14:38:22 -0400
Date: Sun, 22 Apr 2012 20:38:06 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: viresh kumar <viresh.linux@gmail.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, ben-linux@fluff.org,
        spear-devel@list.st.com, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] i2c: designware: Add clk_{un}prepare() support
Message-ID: <20120422183806.GB24810@pengutronix.de>
References: <caa4a0645f80f199b31ec16de37a5c4c9c67a6fa.1334652570.git.viresh.kumar@st.com>
 <b562073871c8c3c13a1f59698f69cfdf65db3b5a.1334662366.git.viresh.kumar@st.com>
 <20120422172611.GA15041@pengutronix.de>
 <CAOh2x=mHS9h6kHxw2of-XWTtv35-SHRRno9Jdkb_3HuDoAovAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <CAOh2x=mHS9h6kHxw2of-XWTtv35-SHRRno9Jdkb_3HuDoAovAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 22, 2012 at 11:08:55PM +0530, viresh kumar wrote:
> On 4/22/12, Wolfram Sang <w.sang@pengutronix.de> wrote:
> > On Tue, Apr 17, 2012 at 05:04:31PM +0530, Viresh Kumar wrote:
> >> clk_{un}prepare is mandatory for platforms using common clock framewor=
k.
> >> Since
> >> this driver is used by SPEAr platform, which supports common clock
> >> framework,
> >> add clk_{un}prepare() support for designware i2c.
> >>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> >
> > ? Can't apply, which version is this against? Looks good otherwise.
>=20
> Because following is waiting in you todo list and must be applied
> before this one: :)

Okay, thanks, both applied to next. If you mention dependencies somewhere
when submitting, that might speed things, a tiny bit at least.

> What are your plans for following patchset:
> i2c/adapter: Add bus recovery infrastructure

My plans are to get them into 3.5.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+UUA4ACgkQD27XaX1/VRsLowCghK/jHJZeDdfheOZa14rdTEJH
YJYAn2T9A1cMVFTDtYeOOeQEDHujKbkz
=Uxxu
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
