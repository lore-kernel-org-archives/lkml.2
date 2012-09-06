Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2IFR36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:29:58 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:44280 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932481Ab2IFR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:29:55 -0400
Date: Thu, 6 Sep 2012 20:25:31 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
Message-ID: <20120906172530.GC30717@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
 <20120906161835.GA7923@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <20120906161835.GA7923@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 06, 2012 at 09:18:35AM -0700, Greg KH wrote:
> On Thu, Sep 06, 2012 at 03:45:19PM +0300, Felipe Balbi wrote:
> > Hi guys,
> >=20
> > here's v4 of the omap uart patchset. No changes other than a rebase on =
top of
> > Greg's tty-next branch and Tony's Acked-by being added to a couple patc=
hes
> >=20
> > Note: I'm resending the series with Vikram's Software Flow Control fix =
anyway
> > as it can just be ignored if it's decided it needs to go into this merge
> > window.
> >=20
> > Changes since v3:
> > 	. Rebased on top of Greg's tty-next branch
> > 	. Added Tony's Acked-by
>=20
> Thanks for rebasing, all now applied.

thank you, actually ;-)

--=20
balbi

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQSNyKAAoJEIaOsuA1yqRESE0QAJzpv2BNoFcpzKHwJ8b9TE9W
Pcr4KgT4f3Khw2r89rBLqQACvye8HQWtci+d2q2gppDH+4nBqT1lwfSbwUoWrloT
yzuVMvZkoRhEuAVkm1l4meIHtyDK42kydoavqP7Drvtycx+PDKzrmZJdtYP6Ntjd
TYfUwF/CKaWKbbRQq/sI1Cj7DUHqujgS2LxHxd+lO18F9iXOwJePuccSiO7vF2Ke
9w/WmFnquuPfA4ttm5HpCSmlLrkk+G+yAGN5XEhaUUj7oJ0sHkg9bfKU/k4WvGio
2kl5R58nA51+2wH6A1I7j2jw0lCDPtsviV6IG/d50/a+3mPW+CLWPUAZsjF1s9S/
8AhPUdT0dluSvWYR9pzGvHAyCW1Gk03vHGYiNc5tZTApG5VSiBJze7alOy+jG860
b5uV6/zkDX2mOg2Or3SRdJCFzTfOfLbUxoV72zhQ6AHj+SsCQkYrNOfD0MvvaTl+
IlqXLQ6YVUkHdLOdZ/OoPrpoAVNUv+7CE9Ma4M+hAEIi+/JXZ3Imrk6VlIzJJB71
Tevx3ZiRL2LZucnvjDNNR5tNxurwdBs8dKwrTiUBh5rwUW09vgV2itB4FN4D8s1e
PVrXvX8Tv5HVtWocJgEqi11Uty+1D5QzqMIIXdtE/5tfXVWLlSausL/RVsohY+L2
tmFS+B/TuHTzcV0ADmpo
=ey5g
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
