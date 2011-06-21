Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1FUHNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:13:45 -0400
Received: from smtp.witbe.net ([81.88.96.48]:39738 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab1FUHNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:13:42 -0400
Date: Tue, 21 Jun 2011 09:13:35 +0200
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net
Subject: Re: Linux 3.0-rc4 - fail to compile...
Message-ID: <20110621091335.49bc46df@tux.DEF.witbe.net>
In-Reply-To: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com>
References: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GwqGmys_oO43X/WoCMLQmgU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GwqGmys_oO43X/WoCMLQmgU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, 20 Jun 2011 21:02:56 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Mostly the usual small driver one- (or few-) liners, and some bigger
> changes to drm (and md). But also two new smallish drivers
> (net/usb/kalmia.c, and the ADP8870 backlight driver). Some filesystem
> fixes (btrfs, cifs, afs, xfs, nfsd).

This is failing to compile on my machine :
...
  CC      mm/page_cgroup.o
  CC      fs/direct-io.o
mm/page_cgroup.c: In function =E2=80=98page_cgroup_init=E2=80=99:
mm/page_cgroup.c:308: error: implicit declaration of function =E2=80=98node=
_start_pfn=E2=80=99
mm/page_cgroup.c:309: error: implicit declaration of function =E2=80=98node=
_end_pfn=E2=80=99
make[1]: *** [mm/page_cgroup.o] Error 1
make: *** [mm] Error 2
make: *** Waiting for unfinished jobs....
  CC      fs/mpage.o
  CC      fs/ioprio.o

This seems to be caused by arch/x86/include/asm/mmzone_64.h which only defi=
nes
node_start_pfn and node_end_pfn if CONFIG_NUMA is set.

Adding CONFIG_NUMA to my .config fixes the issue.

Paul



--Sig_/GwqGmys_oO43X/WoCMLQmgU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk4ARJ8ACgkQZP464AVDf+CvxwCguQClgdkfxTM/Ny3jNcw0VV7X
SwkAn1hrcQucYjw/mINVOhZsybJ6f09p
=cOJb
-----END PGP SIGNATURE-----

--Sig_/GwqGmys_oO43X/WoCMLQmgU--
