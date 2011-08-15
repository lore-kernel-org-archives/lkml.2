Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1HOFqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:46:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56415 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab1HOFqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:46:15 -0400
Date: Mon, 15 Aug 2011 15:46:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: add missing inclusion of
 linux/module.h
Message-Id: <20110815154607.8c34ffd02558b4d86e17e396@canb.auug.org.au>
In-Reply-To: <CAAQ0ZWRX_POwMZY9m9ath=oC0OS538+wRcfj-vay5VSkSRkzEg@mail.gmail.com>
References: <1313375298-18546-1-git-send-email-shawn.guo@linaro.org>
	<m2mxfbmirn.fsf@bob.laptop.org>
	<CAAQ0ZWRX_POwMZY9m9ath=oC0OS538+wRcfj-vay5VSkSRkzEg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Aug_2011_15_46_07_+1000_j70n7j/HWRF2AFTf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Aug_2011_15_46_07_+1000_j70n7j/HWRF2AFTf
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 15 Aug 2011 13:35:58 +0800 Shawn Guo <shawn.guo@linaro.org> wrote:
>
> On 15 August 2011 11:54, Chris Ball <cjb@laptop.org> wrote:
> >
> > On Sun, Aug 14 2011, Shawn Guo wrote:
> >> There are following warning and error when compiling the driver.
> >> The patch adds the missing inclusion of linux/module.h to fix them.
> >>
> >> drivers/mmc/host/sdhci-esdhc-imx.c:87:1: warning: data definition has
> >> no type or storage class
> >
> > Pushed to mmc-next for 3.1. =C2=A0I don't see these on my imx build with
> > CONFIG_MMC_SDHCI_ESDHC_IMX=3Dm, so it'd be useful to see your .config
> > so that I'm able to reproduce in future.
> >
> I guess it's not about .config but sources.  I spot this on
> linux-next-20110812.  Are you trying the same tree?  I will test
> v3.1-rc2 tag when I can actually fetch it.  (Linus released it, but it
> has not been available with 'git fetch' yet.)

It could well be an interaction with the module.h split up, in which case
it will only appear in linux-next.   That said, I don;t get that error in
my manual builds, so the config (or at least ARCH) could be useful.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Aug_2011_15_46_07_+1000_j70n7j/HWRF2AFTf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSLKfAAoJEDMEi1NhKgbsSgQH/34o/6Zw5pahbkeo1tq4yuYF
yVdvt3PFXCtXsp8hczvP2rkXiwovB9fEgHLaPZBd4AS3kQEJ70YUyxw9REsu5gqD
0k9uO5fgLNqY/u9q2eHPnKfWNA2RWxs3Ar1W+f1ZE/f1z9cZWT6lcRnJOB1sBPSx
VfCpYL+qtPpOu1QtSdtvVZj+9anrb2LiKwysQHhmZmr0oPTRrFzRcKcIlkYG+052
ZpOIMVdry0INz0TLGrbaYoJCEdpVyyS2+Q/12IqQQnIW0sYJNOziHFGATMILS+A8
lDOwWSayg8Aw1BKL/kWAC9LQmrlcT/57rJCl6Cq5GXHvkXwp/Mg+6S1gMnE9DHU=
=sKQN
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Aug_2011_15_46_07_+1000_j70n7j/HWRF2AFTf--
