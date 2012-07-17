Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2GQO7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:59:09 -0400
Received: from smtp.witbe.net ([81.88.96.48]:43168 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab2GQO7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:59:06 -0400
X-Greylist: delayed 3744 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2012 10:59:06 EDT
Date: Tue, 17 Jul 2012 15:55:39 +0200
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Terry Phelps <tgphelps50@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        rol@witbe.net
Subject: Re: PROBLEM: Can ping address, but traceroute gets ENETDOWN
Message-ID: <20120717155539.1a6dbfc4@tux.DEF.witbe.net>
In-Reply-To: <CAMUfR_vpEJ=Spd+A5tunDxOttdVk_0RXWHX91HGUf9hGdEa10w@mail.gmail.com>
References: <CAMUfR_tzbEt0BTGwacHKQJQ13iGY8qLimNTFXM_dr5O-RwEgSA@mail.gmail.com>
	<1342531849.2626.605.camel@edumazet-glaptop>
	<CAMUfR_vpEJ=Spd+A5tunDxOttdVk_0RXWHX91HGUf9hGdEa10w@mail.gmail.com>
Organization: Witbe.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.7; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5c6FQME0cZ162MrXPMlWKYa"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5c6FQME0cZ162MrXPMlWKYa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, 17 Jul 2012 09:41:27 -0400
Terry Phelps <tgphelps50@gmail.com> wrote:

> On Tue, Jul 17, 2012 at 9:30 AM, Eric Dumazet <eric.dumazet@gmail.com>
> wrote:
> > On Tue, 2012-07-17 at 09:04 -0400, Terry Phelps wrote:
> >> socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) =3D 3
> >> setsockopt(3, SOL_IP, IP_MTU_DISCOVER, [0], 4) =3D 0
> >> setsockopt(3, SOL_SOCKET, SO_TIMESTAMP, [1], 4) =3D 0
> >> fcntl(3, F_SETFL, O_RDONLY|O_NONBLOCK)  =3D 0
> >> setsockopt(3, SOL_IP, IP_TTL, [1], 4)   =3D 0
> >> setsockopt(3, SOL_IP, IP_RECVERR, [1], 4) =3D 0
> >> connect(3, {sa_family=3DAF_INET, sin_port=3Dhtons(33434),
> >> sin_addr=3Dinet_addr("192.168.118.22")}, 28) =3D 0
> >> sendto(3, "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_"..., 40, 0, NULL, 0) =3D =
-1
> >> ENETDOWN (Network is down)

ENETDOWN should mean your interface is no more in the UP status.

Could it be you have some processes running that could turn down and up
your interfaces ? Anything in /var/log/messages about eth0 ?

Paul



--Sig_/5c6FQME0cZ162MrXPMlWKYa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAlAFbtsACgkQZP464AVDf+CQTwCff/bQcjlSnkNXRm46L+yuh1ER
W3UAnRuZm40FT1V8Gc9WL6uCUjalVAKp
=dTKj
-----END PGP SIGNATURE-----

--Sig_/5c6FQME0cZ162MrXPMlWKYa--
