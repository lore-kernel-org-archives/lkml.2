Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1J0Hpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:45:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:51514 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab1J0Hph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:45:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,412,1315206000"; 
   d="asc'?scan'208";a="67498802"
Subject: Re: drivers/net/ethernet/apple
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 27 Oct 2011 00:45:35 -0700
In-Reply-To: <CAMuHMdUW5PjPU7qNOPA16CbxHJs-bL4r+aFcEGV95SDRBotXRg@mail.gmail.com>
References: <CAMuHMdXxqKoPNNo9a+VK-Yzu0Qp-8zY2+OhHL6pDPF=dsnNK5Q@mail.gmail.com>
	 <CAMuHMdUW5PjPU7qNOPA16CbxHJs-bL4r+aFcEGV95SDRBotXRg@mail.gmail.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-4jNLcPjiK3rcF1vsFyMG"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1319701536.10258.74.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4jNLcPjiK3rcF1vsFyMG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-10-26 at 22:16 -0700, Geert Uytterhoeven wrote:
> Hi Jeff,
>=20
> On Tue, Oct 25, 2011 at 22:19, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > drivers/net/ethernet/apple/mac89x0.c is a driver for the Crystal
> Semiconductor
> > (Now Cirrus Logic) CS89[02]0, so it belongs in
> drivers/net/ethernet/cirrus,
> > next to cs89x0.c.
>=20
> And on the first -next run since its inclusion:
>=20
> | drivers/net/ethernet/apple/mac89x0.c:107:20: error: cs89x0.h: No
> such file or directory
>=20
> it needs the (shared) header file which is in
> drivers/net/ethernet/cirrus/.
>=20
> http://kisskb.ellerman.id.au/kisskb/buildresult/4835488/=20

Ah, yeah, now it is coming back to me why I placed cs89x0.[ch] in the
drivers/net/ethernet/apple/ because it was grouped with the "common"
drivers.  The intent was to group drivers that use common code together.

I can put together a patch to fix this if you are not able to.

--=-4jNLcPjiK3rcF1vsFyMG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJOqQwfAAoJEOVv75VaS+3OiPQP/RjICYdFaHT9Lso/7/IR9Cyq
xJCWWPXHtyHAUOFmaTWbgJgnmDt3KSXuPW5f5DzwbDLxmK72EWSyQc7zU3F8/uDV
4VdXoNYVlB/l6/k6fIXTo1xx9KSs6RaD9tDh8hCXGrLBzCko/udc3FYu2wi00MG8
SknXnNvpQI319Z2YeDCydtnTwWIyThY5mFxVsnFZaxFOxnJbKUU5Os/Ghsr/1kIw
qvdf98PWH0oLVXp0Jd8HXQdQk4a6vBfEMXkzFNWuMdqyryRJ2t0v/CSujS1Bj7hf
m1d5tJpCVquVnvQm4jVu9laZtJtqpsxK5xwEWXTtgmLC6ugvGZLzFiiTbISKaXid
GXGFk+3QJeVONidJZydHv8fGlhMeuVsGc5wibnKzI3LVBA7+h4RR802y7mKpjRX3
Ndnz7JkJuN+SdfR58iIIOvIfaF4DrgUznmOlsN7HCJdiHF0F09tE2COfw0V465Oo
t42heMuD/iO5csswA0a2f53u1aYuL9vvcyYy0i5NuA7/ucq5pl17H8M4a/m0D2Ci
lqvy+Ifqt7ZJoqhdDUru+bg7MVQC0wJTCSunLT72bekWS1gI5sFgwAlNGBq12AyJ
O1uxA34Y16hyQdmMZM2gXzA0MxQApqnxcXzjtd/mxbbMOuaD0tFCzH1UpWFtaFPO
JYY/4zexh8vYlxa7r0pE
=hISd
-----END PGP SIGNATURE-----

--=-4jNLcPjiK3rcF1vsFyMG--

