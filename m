Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab1KIOiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:38:18 -0500
Received: from smtp.witbe.net ([81.88.96.48]:56740 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab1KIOiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:38:17 -0500
X-Greylist: delayed 1084 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Nov 2011 09:38:17 EST
Date: Wed, 9 Nov 2011 15:20:04 +0100
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net
Subject: Re: Linux 3.2-rc1
Message-ID: <20111109152004.48f15384@tux.DEF.witbe.net>
In-Reply-To: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/v0+.TFhec0Z8UXNUzrPxBfz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/v0+.TFhec0Z8UXNUzrPxBfz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, 7 Nov 2011 18:10:02 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Which brings me to a question I already asked on G+ - do people really
> need the old-fashioned patches? The -rc1 patch is about 22MB gzip-9'd,
> and part of the reason is that all those renames cause big
> delete/create diffs. We *could* use git rename patches, but then you'd
> have to apply them with "git apply" rather than the legacy "patch"
> executables. But as it is, the patch is almost a third of the size of
> the tar-ball, which makes me wonder if there's even any point to such
> a big patch?

Is that what made the various tarballs for 3.2-rc1 land
in /pub/linux/kernel/v3.x and not in testing/ ? ;)

I spent quite a lot of time wondering where they could be in testing/ until
I accidently found them...

Anyway, to answer the initial question: no, I don't use the patch-blah
files, only full tarballs.

Best,
Paul

--Sig_/v0+.TFhec0Z8UXNUzrPxBfz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk66jBcACgkQZP464AVDf+BctQCguvXJRvBQP+5jfJY+Mxte0yBX
z1gAn198aHMhxUkHVCbtpdcLhafBtJTl
=9nmc
-----END PGP SIGNATURE-----

--Sig_/v0+.TFhec0Z8UXNUzrPxBfz--
