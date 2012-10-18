Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab2JRRdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:33:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45023 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125Ab2JRRdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:33:44 -0400
Date: Thu, 18 Oct 2012 20:28:08 +0300
From: Felipe Balbi <balbi@ti.com>
To: viresh kumar <viresh.kumar@linaro.org>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>, <balbi@ti.com>
Subject: Re: [PATCHv3 0/6] dw_dmac: few cleanups to the driver
Message-ID: <20121018172808.GA7823@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAOh2x=m_ZLD2shDA_utMoSvNNKkV4=zVDutVb+UOPRPVBnhObw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <CAOh2x=m_ZLD2shDA_utMoSvNNKkV4=zVDutVb+UOPRPVBnhObw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 18, 2012 at 10:34:38PM +0530, viresh kumar wrote:
> On Thu, Oct 18, 2012 at 8:04 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > There are few cleanups to the driver which partialy acked and reviewed.
> >
> > Since v2:
> >  - add one more clean up (patch 6/6)
> >  - make a separate patch to WARN a user in dwc_handle_error (suggested =
by
> >    Felipe Balbi)
> >  - add a description to patch 4/6
>=20
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

FWIW:

Reviewed-by: Felipe Balbi <balbi@ti.com>

(for the entire series)

--=20
balbi

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQgDwoAAoJEIaOsuA1yqREhakP/A3Gwfn8BaLrDRfpTd/Crve9
tjatgyaBEXFwdUkUpo0nZIHtZQcAbXFJO50hA6uq1r/5n/o0gl0MHQYcncaVEWWr
D3RL2tQndiquDARS/UpoCiAT2BOY3rHDlB4Cs1MNpKOcyL6zPKI0VeHgq3hX97vL
r74MZfidP76Q13YH6XjmrS33daOte2eq2nPAivvXM6STXp4JJRCVr9lKIK88xDRz
FkxgdiBbjoF3H0dQEG3qxgH2ZOf4xYDbVAydCyHl6XG6DdO3srndrtRq4t3fgKOe
2nf7THTHNIJvSvP/anAwkSaNNuNqZS7C0ZdUgoIbO3vVVh1khcoqCABz6gWNofzT
6u6l7F+sZILDtVBh0uvuJiD+lKujXnjnKkh2Yx8WLvUN/kC/nhxOU9WvbkDKcq6e
Iu7m9O6JcpfhsOk4KoBczeAUNdGdaX7eX2+dEP+LtrzJ/83D44cl8siJJJoVIL7h
Tno6Ham6VTQg/fhPj444hO7S7D/EHY7q9lwpERcT8YhlSUDaFMIeyx9davm26G0Y
yXEH3kaFEjvQCYGo8Tng13OJ5Jv5e8OQlZW4xI+1fXj3JJnyV2m+AvpN1e22iJHS
Xsjxb8K83u9TlG1CadyW0j554mIeXnQQZ3wD84C0c+oJy0pPkQlyjlN6TAhmv/Ug
NX1gnddzas72EhRYrw/h
=gFkG
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
