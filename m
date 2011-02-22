Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1BVHZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 02:25:20 -0500
Received: from smtp.witbe.net ([81.88.96.48]:45058 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab1BVHZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 02:25:18 -0500
Date: Tue, 22 Feb 2011 08:24:38 +0100
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Dave Airlie" <airlied@redhat.com>,
        "Keith Packard" <keithp@keithp.com>, rol@witbe.net
Subject: Re: [Bug #22542] [2.6.37-rc1] drm:i195 errors
Message-ID: <20110222082438.0c0676ca@tux.DEF.witbe.net>
In-Reply-To: <f14qsMvj2tF.A.rQF._fuYNB@chimera>
References: <JwKd6rET8XO.A._ZC.gbuYNB@chimera>
	<f14qsMvj2tF.A.rQF._fuYNB@chimera>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.7 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5u3yCMo8rgQ8GF8rn4M7n30"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5u3yCMo8rgQ8GF8rn4M7n30
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello Rafael,

On Mon, 21 Feb 2011 23:29:34 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.36 and 2.6.37.
>=20
> The following bug entry is on the current list of known regressions
> introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> be listed and let the tracking team know (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D22542
> Subject		: [2.6.37-rc1] drm:i195 errors
> Submitter	: Paul Rolland <rol@witbe.net>
> Date		: 2010-11-02 14:58 (112 days old)
> Message-ID	: <20101102155813.09cb2c6e@tux.DEF.witbe.net>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D128870991628970&w=3D2
>=20

I think you can remove this one from the regression list. I've received an
update from Florian that said !

--- Comment #27 from Florian Mickler <florian@mickler.org>  2011-02-20 10:5=
2:15 ---
According to #22652 "*ERROR* Attempting to mmap a purgeable buffer" warns a=
bout
a userspace error. =20

It links to ticket #22652 in which Chris Wilson indicates this is warning
about userspace bug, and that this issue is tracked in :
https://bugs.freedesktop.org/show_bug.cgi?id=3D31419

So, this definitely looks like the problem is not in the kernel (though my
personal view on this is that the message itself should be made much more
clear and reflect that the problem is not in the kernel, but in userspace).

Thanks for the tracking you've made,
Paul

--=20
Paul Rolland                                E-Mail : rol(at)witbe.net
CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

LinkedIn : http://www.linkedin.com/in/paulrolland
Skype    : rollandpaul

"I worry about my child and the Internet all the time, even though she's
too young to have logged on yet. Here's what I worry about. I worry that 10
or 15 years from now, she will come to me and say 'Daddy, where were you
when they took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation=20



--Sig_/5u3yCMo8rgQ8GF8rn4M7n30
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk1jZLYACgkQZP464AVDf+AnwQCfakCGcjmaWsDxQ/yAy0/i/ySz
H/sAnioASPsRR/0Uk7fikEF/HVW1a6ou
=l/BF
-----END PGP SIGNATURE-----

--Sig_/5u3yCMo8rgQ8GF8rn4M7n30--
