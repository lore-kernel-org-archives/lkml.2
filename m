Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030458Ab2HIOZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:25:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56289 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030183Ab2HIOZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:25:41 -0400
Date: Thu, 9 Aug 2012 16:25:36 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] ALSA: hda - Deferred probing with
 request_firmware_nowait()
Message-ID: <20120809142536.GA1771@avionic-0098.mockup.avionic-design.de>
References: <20120809103430.GA1560@avionic-0098.mockup.avionic-design.de>
 <s5hobmk2ql5.wl%tiwai@suse.de>
 <s5hd3302ovw.wl%tiwai@suse.de>
 <s5ha9y42os2.wl%tiwai@suse.de>
 <5023BAA0.1080304@canonical.com>
 <s5h4noc2ntn.wl%tiwai@suse.de>
 <s5h1ujg2nm7.wl%tiwai@suse.de>
 <5023C0FC.2030207@canonical.com>
 <s5hsjbw17r0.wl%tiwai@suse.de>
 <s5hpq7017gw.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <s5hpq7017gw.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:YTf8HlwNNZhH0U4rjlj6GHKxZsKWYIvfxSwV0j6mYKI
 ysvC0Tt8MA+sXRBS8CiOcGaGY/s3HuLsCkaS+Tl2vtEveGOOg7
 d5qhtgqLmRUHkaZkHnmtOhfsX5pUAvXTzM31BFbwbPIMbw/kJZ
 HCoTPfy+yuIsfU15TW8q1cfRf91czfCI8LIm6DYxwpIKZtCx0p
 NeY+3NAMlMg18RaJKhQ7WUapEbkrM59u8152Epq8rGVhCXR+7g
 oov1L7I6ZcvxTMT/XcKBtMXR/M0WvwdBUEOx+DxL3kV3gKqEF+
 Li8Q4WCAm2T+mxTLmiRBL3k855USfdFVlYCSlJOPUhIKlvqA/Z
 d0pT9EzUrGKbW56zlRaplf84TwwiYxvjehhLOjrgltTuT9fs37
 kbQW5U/xgg4BKubqpxUmGO1kq9KT/pdbMBUFdvfimt86c5Sd2g
 BvpoO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 04:10:55PM +0200, Takashi Iwai wrote:
> For processing the firmware handling properly for built-in kernels,
> implement an asynchronous firmware loading with
> request_firmware_nowait().  This means that the codec probing is
> deferred when the patch option is specified.
>=20
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
> v1->v2: drop superfluous chip->probe_deferred field
> v2->v3: fix missing chip->fw; renamed the variable to "probe_now"
>=20
>  sound/pci/hda/hda_codec.c |  2 +-
>  sound/pci/hda/hda_intel.c | 42 ++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 39 insertions(+), 5 deletions(-)

Tested-by: Thierry Reding <thierry.reding@avionic-design.de>

Thierry

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI8hfAAoJEN0jrNd/PrOh9wYQALcyzDcHMNrhatB0hlQTq8nt
Qa8S8ZJRzySRnLcAaVqqScBh8VRh1h+Gn+fuVGAbwdhDBtqgKzlaASVwREFH1krd
zTpN+HjOO1/xInb9Nwy5HGh3mo+rO0R0d1+2pOry/z1GDjJe+eSmNbBmvob8qpmY
s/E7xgLc3KNJ6MGst1qBnDoAzKKDCjdMsszvdaIu3jpbiHcJRpBcawjIUV+EB56x
1F5onGfEg++RhIzib6FaU7fP9TBMkoYidnwDzvsN4O6jpI62vm5bwxjeFi00tL+7
qygILoAuxy6snqvfeicUpe4L80duzh/bKireTNi3IWJGbuyJxNgSMPc3ulS+KXmq
c9kqneGMBENuHC74tVyLPnsIii+l1V5lxuu8YBFRrrnlmqrxPwyBY2Fimm9NPZZC
nCYiA/+wrhKGOpag8K4xVNMKS8kGVcu6Fiwwo0cY5HrEVZyuzY04dc+i+AMmdMqf
Frmxwu+mzt4koOB0yZ1g0h2a33vOl/ZsSK0RGU8ZOJXeYTR138HP5myAW6ou0Fxa
1y62Ryb1kFgs9a0jJCaPTDRsvM6PrFioU+K7h7W3Ru9Fe5Zb47xkvOfx7MdO2YX9
pF5llQYaOdOzg/cKA/Zp8rEPztrwOei+BMkNq4bjmZo5WPYQbkpR7FLnSsVAt3jq
LvHtZwlzeSw0Uk4Uk1gE
=6MGG
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
