Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2FYJDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:03:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39149 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab2FYJDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:03:43 -0400
Date: Mon, 25 Jun 2012 10:03:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajeev kumar <rajeev-dlh.kumar@st.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Liam Girdwood <lrg@ti.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20120625090340.GD4037@opensource.wolfsonmicro.com>
References: <20120625141140.c6d71065dab293005514ee1a@canb.auug.org.au>
 <4FE8009A.4020503@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dvhSTuvbbQltApUS"
Content-Disposition: inline
In-Reply-To: <4FE8009A.4020503@st.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dvhSTuvbbQltApUS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 25, 2012 at 11:39:30AM +0530, Rajeev kumar wrote:

> 3. We can pick the patches circulated by Viresh Kumar where we don't
> have HAVE_CLK defined for x86_64, then the inline routines like
> following should come into play:

This is what *should* be happening, in conjunction with architectures
doing the trivial work required to turn the clock API on now that there
is a generic clock API, but both of these things seem to be going
nowhere.  I've applied a bodge until someone decides it's worth applying
the stubs.

--dvhSTuvbbQltApUS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6ClTAAoJEBus8iNuMP3dMBAP/1W4nKgzNNvyW9Wv/YS4AgID
a5maD8sDllnl0QSAdLzsft5fDj2Qzpze+XMDNAGUeU4m//gnPJrKyZx4J6X5nHzk
rGtvJgE3s0KhYHoIGulJ1bnYqdVHFdSNyoHRz2drdk117UVfWgfNZikqppT4dJRF
y5ZEo1rjroWuEjK4GqDQJFgJvPhZW4AyQI/R+BEOZpH0KKSry4nl8AupkRc0e87q
Ytw/xSN1jhEWaYFrjaQOLdyNQ8HdTqlAQlcQZETwm5R3yBtkUNJwrRHpX+Oz7e+r
flpBuECuUHK5FhtV5wBYTtfn/ddoVyJFAGhQwZegmIqsjdLSwB94yX/iE9yra/3/
4J0e+r75dKSPVPrb3oW8S7McumPT9wH/T5Tu8gh5CzEPs2iURsIJ3VDjsCCjkhnX
A9cDEZWfD3KZWh2iwG3qaAbC1KBynlw2gXAF3YMdk+wuu06wjXcKdK+pfGqiDEXE
a11kLHnbyh0TkUl+EiZho642GEz5rnd+s2pG8IO+4tr/9ZtMuFPMHsxbZPC5ciTG
GrPENXFg8QPxsqRgJhGS3goMw6lfwsF/ywMsA17WMxS9Hi/G03WhTmJQrDzd1Nmd
+Rn5B8a9I/QIw0kkRNJXzJGDBeUyJZHHmYAIlStV19YMBTsMfO/Kbg5lCUsp4Mgj
nlBAg8jhjq6UdsFNX3iC
=Gdng
-----END PGP SIGNATURE-----

--dvhSTuvbbQltApUS--
