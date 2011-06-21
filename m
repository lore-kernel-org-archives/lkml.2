Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1FUPNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:13:47 -0400
Received: from smtp.witbe.net ([81.88.96.48]:55455 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab1FUPNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:13:43 -0400
Date: Tue, 21 Jun 2011 17:13:30 +0200
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rol@witbe.net
Subject: Re: Linux 3.0-rc4
Message-ID: <20110621171330.10b6730b@tux.DEF.witbe.net>
In-Reply-To: <20110621150544.GA2717@elliptictech.com>
References: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com>
	<20110621150544.GA2717@elliptictech.com>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5Zz2vGK5sOXmTO_MRGQ4VlS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5Zz2vGK5sOXmTO_MRGQ4VlS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, 21 Jun 2011 11:05:44 -0400
Nick Bowler <nbowler@elliptictech.com> wrote:

> We're at -rc4 now, but it seems that the following patch (drm/i915: add
> missing intel_enable_plane() call to i9xx_crtc_mode_set()) has not made
> it in yet?
>=20
>   http://permalink.gmane.org/gmane.linux.kernel/1148279
>=20
> The i915 driver has been broken since 3.0-rc1 without this fix,
> which has been available for 3 weeks now.

Could that explain why, connecting a second monitor on a VGA connector, and
activating it, result in garbage on the screen, for both the VGA display,
but also the LVDS ?

This is what I can observe since 3.0-rc1, 2.6.39.1 was ok.

Best,
Paul

--Sig_/5Zz2vGK5sOXmTO_MRGQ4VlS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk4AtRoACgkQZP464AVDf+AwPwCdGuFdxKGXGRwLC3t7Y8ZJd6Xq
EwUAnRWfyZQbmfYNs0Lrb7njxCQZAC5V
=vJha
-----END PGP SIGNATURE-----

--Sig_/5Zz2vGK5sOXmTO_MRGQ4VlS--
