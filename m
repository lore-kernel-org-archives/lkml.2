Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2I0TkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 15:40:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53332 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2I0TkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 15:40:18 -0400
Date: Thu, 27 Sep 2012 21:40:11 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: guanxuetao@mprc.pku.edu.cn
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Qin Rui <qinrui@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] unicore32: pwm: Use module_platform_driver()
Message-ID: <20120927194011.GB5483@avionic-0098.mockup.avionic-design.de>
References: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
 <1347956633-15667-3-git-send-email-thierry.reding@avionic-design.de>
 <50847.162.105.203.8.1348282590.squirrel@mprc.pku.edu.cn>
 <20120922073207.GB2538@avionic-0098.mockup.avionic-design.de>
 <54116.162.105.203.8.1348310959.squirrel@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <54116.162.105.203.8.1348310959.squirrel@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:sej9nkU20EiKu5xAl8xK5xI55H8mgQ5STIxaGfMTS5g
 2k2ifExhDowWnXI4cK6NDzSMLAkDihIc/92w8jV1YJpLGSLfsO
 S8WtlhJiM7rz3SbG0GvqOvfn79GV/K1W0FmSHGG5ixFTc/ksi+
 Nm5He/hMzMl+1SYQdg8y/6DJzBt3GfxKkvgEsZ7kym9iB6eQji
 EdS8D77H092O2kEN6ZU+rKt3yMssrNuMxCgk2Lg5/Rs9aP9BKU
 i7pST4UtxHrQ74oidy03HVS/tjzIkvgrIXz6DzWgdOhCZtASgN
 8SNfJ8Ns3SDnpq8EAmEpHnNaR+Gof17HcrToSG54RRAILv9zZ0
 sggUZZi8QotQf1EpUk3JuiKYob7x5C/nrmLNeGPDultGnRpRFq
 0kat1yehKSQX3hyvwlWFQFxLJWo7/cBuZg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 22, 2012 at 06:49:19PM +0800, guanxuetao@mprc.pku.edu.cn wrote:
> > On Sat, Sep 22, 2012 at 10:56:30AM +0800, guanxuetao@mprc.pku.edu.cn
> > wrote:
> >> > Some of the boilerplate code can be eliminated by using this macro.
> >> The
> >> > driver was previously registered with an arch_initcall(), so
> >> technically
> >> > this is no longer the same, but when the driver is moved to the PWM
> >> > framework, deferred probing will take care of any driver probe
> >> ordering
> >> > issues.
> >> >
> >> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> >>
> >> Tested-by: Qin Rui <qinrui@mprc.pku.edu.cn>
> >> Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> >>
> >> Thanks & Regards,
> >> Guan Xuetao
> >
> > Great! If you don't mind I'll take this through the PWM tree with your
> > Acked-by.
> >
> > Thierry
> >
>=20
> It's my pleasure.

All patches applied, thanks.

Thierry

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQZKubAAoJEN0jrNd/PrOhV4wQALBMuH6LqGb/aLUdRpaJ8++F
FPH96c/YAgIgQpAhCTE7j7V7CVXHbBB3OdmW0PUMv0q7shpQ964PVR3kiKDqrDD4
M54oOqFHSZ8pKBUKd3yKX3fxryY/1pq03ZDON1klpCHiiNKORShU1m6C2mMSe4ds
FXggoJH7swbHGltGMgn0u7z3wMkfNvUphnm+/81uJ2vZL7laFTzPZtgwC9CMpT9S
5+QIVa26PPRpUO7sKUgcztevp4mE0CGSfcBKkvnoRld0boc942Y6YDhv2JvUERdO
vrVCAX+SCkyRIGHJk66UDIQjk5JlGp6hDuShYOq6JTG+vQRJOYyETYfs9Uq1HVmj
VmOTPN4tIzM26fVL71sTwoRkw2Q+ge1Za3MWZPaV4so3d3N46lXRrJ6alAc6dEkc
Qhamrwq6jveoENHvZFjxaFI5VvvTTY6x02paQ67UW8Khkt9ufmvwODS5MLteOvid
IN80gfIxJKrdo1zsu2o5UfuPOfGRA9nNZuT3amHpoyHh24KKd4vTh5mF/YfYW59o
VsPfvHwVWXp20lZvXEt9dUk00E3CcOoq4CcLJ/WsFQSX+HeanBoBbvapeTX5ihh1
RgB/guiNPODG28sUbsKE9Zcf3u7rTNxZY5OnS7cXtmRuf7c7wwKdxxhSr+K/evav
XnGAHMMvzsKuk6G3k96X
=VoU7
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
