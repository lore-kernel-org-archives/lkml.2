Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab2I0IOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:14:51 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:55057 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756196Ab2I0IOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:14:40 -0400
Date: Thu, 27 Sep 2012 11:09:42 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: balbi@ti.com, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
Message-ID: <20120927080940.GO12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
 <20120927074912.GK12592@arwen.pp.htv.fi>
 <CAHp75VdEyQP_kDeQgEanyfewQghvsAntLHKDNZGjte6Osc1kcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqN4RWvJTb9VNux/"
Content-Disposition: inline
In-Reply-To: <CAHp75VdEyQP_kDeQgEanyfewQghvsAntLHKDNZGjte6Osc1kcw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tqN4RWvJTb9VNux/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 27, 2012 at 11:08:12AM +0300, Andy Shevchenko wrote:
> >> +     .is_private =3D 1,
> >> +     .chan_allocation_order =3D CHAN_ALLOCATION_ASCENDING,
> >> +     .chan_priority =3D CHAN_PRIORITY_ASCENDING,
> >> +};
> >
> > This is the same for all of the PCI IDs listed below, looks like it's
> > best to just add it as platform_data of the dwc_dmac device directly,
> > rather than passing a pointer to this via driver->data.
> It potentially could be altered. I prefer to leave it as structure in
> the pci driver.

fair enough ;-)

--=20
balbi

--tqN4RWvJTb9VNux/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZAnEAAoJEIaOsuA1yqRETHoQAJlwrpN9A2tRpBzWdfndanLK
kdNpCh9d8vyLUQfbvgjui110A+Ody2Gl2xFzrt+/sTSCUpxfXH23eny1QMZXLwBa
qcuOyW5aSeyB1hk4kB9YBc+NmTRkMkUAdaWfOSxkHhTOIO6A/b0v1t2pOFKM1BHu
uOwyHt4xqHq+m6gn+ijbwnNVAxbo7JFY/eyTHYDx+uOabLDzC26bcrL0Z0Evua61
47w601StklyKtRnf/dhK9p1YcfDStNLY7hrnHO2Ua6FNSQ1w3bq7KBSvnqxusdy2
sFiO1AzamcseW+MZdXo1oyqdijVxKZVWyNYEK/Fejo8QfKwawG52jqlvWr9lmwEI
DPNtfs5UuzU+ddrf86sc9uD1wIPWJ4DJKXztEvoo6h00UUAwRLjjXZfWvrzdH7NS
4FWbr8UNr8yigrPD7IknOBe11x3K2ccQIcuevrMrW+k4/UQDJMT8/R+HX3mcEbDm
oSC9/wk/+go7MEtUZnimYcFcHvxmHOSKiIKbt1bXrC0y2FhFu9x686wlign5aadz
CHmNV1I0P6KeqB236gpo3nsY4sy+ZCFQAqqHk7huS3UbgBYi09XN0dx341pSf2WT
1rOaO5rLWl0PcntvuMf1gwKPq/o+cJQ7coUsU8k4Ve99mB3F2/RiuCQYvjVfuvwk
5T+apG0C3j9JYTWTiKAr
=1fFi
-----END PGP SIGNATURE-----

--tqN4RWvJTb9VNux/--
