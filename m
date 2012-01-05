Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab2AESC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:02:57 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:47049 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755488Ab2AESC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:02:56 -0500
Date: Thu, 5 Jan 2012 10:02:51 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Keith Packard <keithp@keithp.com>, "Airlie, Dave" <airlied@linux.ie>,
        Intel drivers <Intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PULL] drm-intel-next
Message-ID: <20120105100251.3fc7dfef@jbarnes-desktop>
In-Reply-To: <20120105152408.GD3831@phenom.ffwll.local>
References: <86y5tmkeia.fsf@sumi.keithp.com>
	<20120105152408.GD3831@phenom.ffwll.local>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/60lu0j27.U_bJjye.L40_r5"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/60lu0j27.U_bJjye.L40_r5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Jan 2012 16:24:08 +0100
Daniel Vetter <daniel@ffwll.ch> wrote:
> I'd also like to express my frustration with the general -next process for
> drm/i915:
> - This drm-intel-next tree is less than 24h ours old (if you look at when
>   it showed up at an official place where both our QA and the community
>   can pick it up and test it). I fear we'll ship yet another disaster like
>   the stack eating bug the vt-d/ilk w/a patch caused with an unbounded
>   recursion. Our QA actually caught it in testing, but there was simply
>   not enough time to fix things up before the buggy code landed in -linus.
> - Because the drm-intel-next merge cycle started so late there has simply
>   not been enough time to include quite a few bugfixes for serious issues
>   like 20s delays in intial modeset, userspace-triggerable kernel OOPSes
>   and deadlocks and reproducible hard hw hangs. For most of these there
>   are testcases in intel-gpu-tools, and these issues span the entire set
>   of hw generations drm/i915 currently supports. But this late it's imo
>   no longer advisible to merge them, so we'll ship 3.3 with a bunch of
>   known (and sometimes longstanding) serious issues that have fixes.

Yeah I have to second this and additionally complain about the patch
lossiness & latency.  Part of this is my fault for not reviewing things
as much as I should, but those reviews often get lost too...

Eugeni's i2c patches are a good example.  They've been out there since
early Oct, have received review and testing, and should have been in
-next for many months now (in previous releases!).

What can we do to improve the process to get trees updated more
regularly and get fixes integrated faster?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/60lu0j27.U_bJjye.L40_r5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPBeXLAAoJEIEoDkX4Qk9h+9sQAJeUuRI0cHXcveq63cv4yz3W
WojPQVfIpruHbmdW12eYom7piEpSlpjV8wGUPFakYskXYT9mBmUdrwLCYDh9ZIaT
ETuo8w0lAf0LaYheyH9HjGHh5Q/rbstS6cX5lQM22JMK/ygakkbfiHOoci7KJpUZ
6+j9082MN1Gk3vgZVyzKCMAniEOkT9ed/N4nj80zRdlZ9Hs6yWkWcHDwkHSIp1S9
A7rk6mL4wOZMgA+3L6ndaK4lFQ2H+3M2XPq1upzx9tyn36OVtPqapbtc8Sxr1IyT
KO1yn7PnfsB2IzWw7pMK92w3EVC+fxt4dc/TOB8SDge92ceRP2x5naIZVAv0556d
9UYPUPj+IrqqkQCFIbyq2KKzEH731t2i/T/IZpCPwhSFD2pukA0+VITn/Utp3vP8
1NDQ4u8pVsQ/Vdd4pIHX6i7TywQL5o0/z55gIzVb+G1I0ynI1ZXnIJ7lobrh4mev
W3B2T4fDXRQ2VF8KLLg9s89jSvxCbvc32yDgN+V4CL21AM7wwR58z67b0kk75PzN
e63z+aLg+bnBGjaoNunKgIV+VtKHO8qV72yZEiOE8MPs2+o13JaAi+RGcgULKGBr
EDfXj6oBlkcLaTfYD5N7VXwo9QVuUgf1EPiDtjltaIAuR829NwKcubca0iZSvJ6Z
pLs5OEfrzyVjXa7ugzMq
=spbn
-----END PGP SIGNATURE-----

--Sig_/60lu0j27.U_bJjye.L40_r5--
