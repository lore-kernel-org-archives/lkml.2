Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2CIMnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:43:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58343 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611Ab2CIMnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:43:41 -0500
Date: Fri, 9 Mar 2012 12:43:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PULL-REQUEST] EXTCON Patches (Re: [PATCH v6 0/5] Introduce
 External Connector Class (extcon))
Message-ID: <20120309124337.GW3273@opensource.wolfsonmicro.com>
References: <CAJ0PZbRsh_Cnqy8Vtf1FWLajBr=R5iQ=Jog+w+qPE-uKrh5XQA@mail.gmail.com>
 <20120228164413.GA11021@kroah.com>
 <20120228165727.GO3683@opensource.wolfsonmicro.com>
 <20120228170246.GA11415@kroah.com>
 <20120228174505.GP3683@opensource.wolfsonmicro.com>
 <CAJ0PZbT=yD3SFBVYbcL37Dgyc3UVzk2LRQ_VWABW4cY_hfDuHA@mail.gmail.com>
 <20120229123511.GA7730@opensource.wolfsonmicro.com>
 <CAJ0PZbQVO-NMO_DxuSuY5xU3zXus=x+x3SFpXZEcA7n-CGX9Uw@mail.gmail.com>
 <20120305120743.GE3224@opensource.wolfsonmicro.com>
 <CAJ0PZbQ3nJXUnzVrKa8qWa852FawJtzZVSANG=ry_Sy0-JuFVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pEAjBjStGYT6H+Py"
Content-Disposition: inline
In-Reply-To: <CAJ0PZbQ3nJXUnzVrKa8qWa852FawJtzZVSANG=ry_Sy0-JuFVg@mail.gmail.com>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pEAjBjStGYT6H+Py
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 09, 2012 at 05:26:26PM +0900, MyungJoo Ham wrote:
> On Mon, Mar 5, 2012 at 9:07 PM, Mark Brown

> > The issue is the combination of the naming (h2w isn't very meaningful
> > and only works with a single jack) and the magic numbers used for
> > reporting state, plus the registration collisions. =A0Existing code can=
 be
> > ported over fairly easily but it's got issues as an ABI which we'd want
> > to fix.

> The ABI of simply ported (only with API name changes) ex-switch extcon
> device won't be changed:

> Or, do you mean that extcon class should support not ex-swtich extcon
> device drivers such as adc-jack.c (not ported from oldies) to support
> "legacy" userspace application that is aware of only switch interface?

Neither of these, I mean that we'll probably want to do some updates to
the drivers as they go into mainline which will change their interface
beyond the simple s/switch/extcon/ change.

--pEAjBjStGYT6H+Py
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWfrVAAoJEBus8iNuMP3d0BcP/0ltfUl+JuF4rQGpmvNhl8nw
KnmLp+fN3UJfuPpdgffgRjOV/S1C44hTjFJZnh9ZTtKg3FgZcjS82ZQC80Er7rVx
z528ihe7GuZBuW5gWd/eDWLic1YrTCb3LSfShw2BtIu14PwJIG0nhlqWnbVcZAri
zzOwo9zFJuzoHqhscJ0qghkkl5/UGsRkitSynNtkrnckzTXnu+7j34qcaPwunxCn
CCzYCsCCTgXG9jQVoNYKHEuGNGiSMi3LPrbz+rkZTl8+SyDKBQjbjXRUaj5g4DWw
c8291OVG+eIoVsBpFNRJpGcWdY/Q7Dfk5onFTI4h/hsWbyCTJecMU4jRovcCDmRb
6ggLj78966jtKw1ZV6iRltcwGOWeFDaiKI4euDm7ifwBVlBFJ8za5oXvrrCbmBkk
n4doFFR0fvmjmmdR11zNI0KUGONhJaJadR8shQ2U3mK/D7+UXWL54L+Vo+H7lPq/
eSZ3bgglu+k/aR/V30wtik24gH4vaNckYaSYpLpsTfuOQLIjDNv6p4nKj8eefE5r
gFdWUSvdLDAfkZSotBZLXLBcPnU5N5e/U3ZM/EoUSaaMKnQYH85XFvMJlfkV5b+y
WLqBDc5ODtVv31Xu6yqI50wrrG6HvzApQNsfcMJMb0AJZm2z+PmSrVlG4Qp1IwoY
yCbWrQrLgbc70F/OMJ66
=edGN
-----END PGP SIGNATURE-----

--pEAjBjStGYT6H+Py--
