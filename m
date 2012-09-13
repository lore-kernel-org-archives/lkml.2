Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2IMFGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 01:06:17 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:55899 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755199Ab2IMFGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 01:06:12 -0400
Date: Thu, 13 Sep 2012 08:01:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
Message-ID: <20120913050136.GA6504@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
 <alpine.DEB.2.00.1209062137000.11516@utopia.booyaka.com>
 <alpine.DEB.2.00.1209112141220.9444@utopia.booyaka.com>
 <20120912062259.GC18563@arwen.pp.htv.fi>
 <alpine.DEB.2.00.1209122025020.17903@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209122025020.17903@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 12, 2012 at 08:25:30PM +0000, Paul Walmsley wrote:
> Hi
>=20
> On Wed, 12 Sep 2012, Felipe Balbi wrote:
>=20
> > On Tue, Sep 11, 2012 at 10:02:48PM +0000, Paul Walmsley wrote:
> >=20
> > > The bad news is that N800 no longer boots -- or the UART dies during=
=20
> > > serial init:
> > >=20
> > > http://www.pwsan.com/omap/testlogs/test_tty_next_e36851d0/20120910020=
323/boot/2420n800/2420n800_log.txt
> > >=20
> > > The problem doesn't seem to affect the 2430SDP.
> > >=20
> > > Could you put together a patch to fix N800?
> >=20
> > I'll see what I can do. BTW, is that log with DEBUG_LL enabled ?
>=20
> Yes.  Here's the .config that was used on N800:
>=20
> http://www.pwsan.com/omap/testlogs/test_tty_next_e36851d0/20120910020323/=
build/n800_b_testconfig/Kconfig

Thanks :-)

--=20
balbi

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQUWiwAAoJEIaOsuA1yqRECcsP/0fVRePaVGS+40VRURE2Ipkq
Yxitl7hP0B6Mc6MadkdC0iuKLMnC4Lp2yKJfje/cIpeE9JWVmsmtofdW9r+RTHax
Emq2IRVBHGf1UL+vnaz57JhZ0ys4E2CvxO2Dk51MwJoRcIhky5MbnyywtlkbKR0p
sNRex4dH61UHiYzaS7cFpoamvTOdqdzh8OBzzyvhokEyV7VwmuRSrfAdjkB1xWv7
7VC083W/+bpHkIUyjWbN0N8nc2HwAoMuKStfGrVscXUscFxucRngx5Xl8FRqofmw
sZX91W7X3pcbTJSeUeyh1PpUyP4RFAQMaSvBmzy7hwwxrR4YZm9fRedQ0LCSLp48
As43SQSa/nfNo8HdX7pPuPUr1x2gGXbxhQCEakkI+Lq6IQLVtNQetuvrzkROKnfR
g6NdofLwTBpCs/4ikyGXXZLg7P10VhZ6XbSfWdbouQHLdl0jWiR5F5xYcRwrOK/w
lB8zgoQmLK+RFH1EbtEQKnMPJ1dJQPN/fBvbuMOWNCkEnAGez8DgtjcsTah2Csng
u9peIjLFTtp0/qbMqCh/xOdE3zzZ/gxSUKUw3gTSolPOTBQAO1ySSu8KhoYTpnU8
aNwk0q626j1yT/vR6IOYC/SyzlAf/YDLWQGqokBusI5O8vZ1Whcg15uCgU+yb/1I
rEmXvehLh8ZyBQ7RC0uX
=YsWe
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
