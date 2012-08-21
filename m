Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab2HUKil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:38:41 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:38651 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756375Ab2HUKii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:38:38 -0400
Date: Tue, 21 Aug 2012 13:34:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: balbi@ti.com, alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: Re: [RFC/PATCH 05/13] serial: omap: drop DMA support
Message-ID: <20120821103438.GQ10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
 <1345540555-24359-6-git-send-email-balbi@ti.com>
 <CAMQu2gw93ES=u9J1FfWK_CKkgUq8V487+tmKtQ34p8O7VJ6aHA@mail.gmail.com>
 <20120821102045.GL10347@arwen.pp.htv.fi>
 <CAMQu2gyGVhB63rn+G6B3nFLki5ib40C_2o2Bh1mBd8sw8wT_Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UJEqbsikIZBgizPR"
Content-Disposition: inline
In-Reply-To: <CAMQu2gyGVhB63rn+G6B3nFLki5ib40C_2o2Bh1mBd8sw8wT_Ng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UJEqbsikIZBgizPR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 04:05:22PM +0530, Shilimkar, Santosh wrote:
> On Tue, Aug 21, 2012 at 3:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Aug 21, 2012 at 03:14:19PM +0530, Shilimkar, Santosh wrote:
> >> On Tue, Aug 21, 2012 at 2:45 PM, Felipe Balbi <balbi@ti.com> wrote:
> >> > The current support is known to be broken and
> >> > a later patch will come re-adding it using
> >> > dma engine API.
> >> >
> >> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> >> > ---
> >> Thanks Felipe !!
> >
> > no problem.
> >
> >> One less driver now towards OMAP DMA
> >> engine conversion.
> >
> > indeed :-) I'll take a closer look into rx timeout IRQ, but it looks
> > like we can use it to kick dma only for "big" transfers... need to play
> > with it for a while first, though.
> >
> Yep. The RX path with DMA is bit of difficult part to manage for
> UART.
>=20
> >> FWIW,
> >> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >
> > is this Ack for this patch only or the entire series ??
> >
> Two more patches to review and then I will do it for
> full series on top of the cover-letter :-)

cool, thanks

--=20
balbi

--UJEqbsikIZBgizPR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM2Q+AAoJEIaOsuA1yqREI+0P/i1WowkakjnJRnsPwZGIrJ7x
8EiEcFq/DE40yIn1VDlNWUbhzSGB6G+8J2ldXUsIxoj2JVdvbWmIknShly3Cg7LT
NZB/DU6Srw2HwP1nGvwpDj1GqeZu2KYjh5tYJu25dtTvoVJ48N7il4G9qcmjF2X4
WA4194aG0/P0ixWadXEWR+LVzBBlz/EU0X9lzaenVIYzhBPJuydr3nSo+wrxlpFQ
QqbaVQ56A8p7B4acJ0fJxpDmaIzVgsXKPtkK5tdsHFgO1rV8CwsiHqOZV6guehy2
8TvejxTw1UqE6fTSznzNdUqysFIIMe9lGtdQaO3HqXTEKq9iDKIyYwT/81Cqy2qe
v6/UOWYAXfUKbMu2ji8zZloMpRAhMvuSRGeehTRF9wyRNHsaVfDdNAwftuA5vy/Y
ptqrFizKPDNM54yAvxltAoV47SeuHXfwInXV7ubw0Nh36M6a/LFDxnH/jwXIRFkb
1QvS3nZF9uRG1OYD08tzirHNP8kRiQ9PfHqTGpK3nZ9Q7Vt/pOS5UGVscPFy1w8n
kPCdH45Z/uZfBlMO43z/WgTXi6rSYGrJIyQxcCWGgLWhlG76osbiRMyOmmCiR5pH
u0+00X0T1HK6aLH/FN0UzqkBVEFBmXQKlSc9KJUxIVGNvIcKDvxCEfGUdB7PjzKJ
GeUTmixWpRsjLD+zjeWV
=NnQk
-----END PGP SIGNATURE-----

--UJEqbsikIZBgizPR--
