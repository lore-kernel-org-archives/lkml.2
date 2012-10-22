Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2JVMHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:07:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59454 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2JVMHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:07:14 -0400
Date: Mon, 22 Oct 2012 14:07:06 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Prisk <linux@prisktech.co.nz>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
Message-ID: <20121022120706.GA19467@avionic-0098.mockup.avionic-design.de>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
 <1350888712.3592.11.camel@gitbox>
 <20121022071118.GA30026@avionic-0098.mockup.avionic-design.de>
 <201210221150.22004.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <201210221150.22004.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:wPpc/bkiKCoJ1nlbYgrcT1jBLTcI4fjkDUDy303g56p
 HWyc30k/Tw/8n0wYRAXmcWZzqZUmTzKBXpUnSITpRHtqdysH4t
 VtWUAfV4ejigvEL937TLIaJOFoDdTnpebWn/Mlcuxj8XBdUE30
 zUVdxJtJ0DMmISZKlrRqMlERINuBRiMe95ksGKH/jSQnoscQc5
 R7eCpZb/AMeIVcqDY/+yVDL2wWi8WrBJVg/PXgY285fwvO5nwF
 8Nu1st85rLXhj7UJ6o9xQD+W+yoLG8k9ZQ9CFCDjwVTFyKsfqB
 LT+cO6GSeRaFypSXxZ6J8fuodFBaaFsxLcXUaX3LCVUosMnILn
 oUe6mcNubsDsKDQqNjpObr9C0KKTspDZ6JS0wTGiHfIfxfWM/1
 hRGqnnz1W2K54Ra2VSuVtiFhn6f4oHI0hY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 11:50:21AM +0000, Arnd Bergmann wrote:
> On Monday 22 October 2012, Thierry Reding wrote:
> > On Mon, Oct 22, 2012 at 07:51:52PM +1300, Tony Prisk wrote:
> > > Replies to your comments inline:
> > >=20
> > > On Mon, 2012-10-22 at 08:34 +0200, Thierry Reding wrote:
> > > ...
> > > > > -static int __devinit pwm_probe(struct platform_device *pdev)
> > > > > +static const struct of_device_id vt8500_pwm_dt_ids[] =3D {
> > > > > + { .compatible =3D "via,vt8500-pwm", },
> > > > > + { /* Sentinel */ }
> > > > > +};
> > > > > +
> > > > > +static int __devinit vt8500_pwm_probe(struct platform_device *pd=
ev)
> > > >=20
> > > > Since you're changing this line anyway, maybe you should drop __dev=
init
> > > > (and __devexit for the .remove() callback). HOTPLUG is always enabl=
ed
> > > > nowadays and will go away eventually, in which case these will need=
 to
> > > > be removed anyway.
> > >=20
> > > Will do. I must say the inconstancy among comments is rather
> > > frustrating. In another patch I sent out a few days ago (completely
> > > unrelated to this), I told to add __devexit to a remove() function :\
> >=20
> > This is a rather recent development, so maybe not everyone knows about
> > it yet. You can look at the following commit for the details:
> >=20
> >         45f035ab9b8f45aaf1eb2213218b7e9c14af3fc2
> >=20
> > It's been in linux-next for about 6 weeks and has also gone into
> > 3.7-rc1.
>=20
> As long as we get build warnings for leaving out the __devinit/__devexit
> annotations, I would generally recommend putting them in. If we do a
> patch to remove all of them, a couple extra instances will not cause
> any more troubles than we already have.

I've never seen any build warnings for leaving __devinit/__devexit out.
Where does that happen?

Thierry

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhTbqAAoJEN0jrNd/PrOhVQsQALXPdXeOqksWFQNXvBbpqGW+
p34VHr793rzP7DJyrneecXRYjiMrhqoed9HbNiOtlIDf/UR6GJpQlkwWzl6euGXe
GSjruZVFT8jigQ3vyToeiXPvVBq90PsxksaFz/s7rnx+F0azWummBkCQk+U987hW
gJEIb49vtHQ6zBxVKRbvpQzYML8jSeaBM/J44QAJOvhvrc4cP/S61lrKK0SzGL6d
VFLS1LWdyZaevS5d0z0GsbvVnkNPOF5o+WqS5EqXs98cFv+jYN0HHDYFO3u7hiXx
vEb/GM7yQBI1toZCclCx/MzV8UxTplfM9cRhwU64nfb6ubhTAARYkh2fEQ52Ompq
Cug8cz/UQPb4cdNFearO1MXMD6cca3hm8Iyu7oyP4CI6SvdQjrctMsSuQeE4uB1Z
Cg82pt8E9LclljeZNBr6Por6u6ZEU1C9rfzwQwIEHCk/8mTWwSlsq49nku9qQDES
2Lpmd149mFrSfBwYNEt0XpaQTXNrmsnICCGjPsYhgp3ExQm1y1NAqxgmQREyqhXx
DIZkmKC+2oMrLMoIIycWXdw8o2A8oEqlcCqbDyyvfOyGJ8ILAz69tdriKjn21zoK
liTJgMtcCTCcGjAVp2yMbpNPiEjtboWyIO0Ann+LLswTNYR3jQt4jWFQeIXmxMZR
FrPFt3BV2GYtpXOR8OPt
=K14Z
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
