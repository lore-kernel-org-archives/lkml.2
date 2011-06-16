Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab1FPPpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:45:21 -0400
Received: from smtp.witbe.net ([81.88.96.48]:34768 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705Ab1FPPpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:45:18 -0400
Date: Thu, 16 Jun 2011 17:45:03 +0200
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, rol@witbe.net
Subject: Re: [3.0.0-rc3] GMBUS timed out
Message-ID: <20110616174503.7e5cdfa2@tux.DEF.witbe.net>
In-Reply-To: <d08817$d6fmn@azsmga001.ch.intel.com>
References: <20110616154123.259414a3@tux.DEF.witbe.net>
 <d08817$d6fmn@azsmga001.ch.intel.com>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0cUAX=0X6D4wGvhIXYC=BfR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0cUAX=0X6D4wGvhIXYC=BfR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Chris,

On Thu, 16 Jun 2011 15:08:48 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> Attempting to use GMBUS when enabled for 3.0. It will have to be
> disabled again until the GMBUS/GPIO adapter aligns better with the i2c
> interface and doesn't cause a deadlock upon booting with the eeprom
> module.
Hey, that sounds promising ;) Glad I don't have that kind of HW...
=20
> In the meantime, if you have the time and inclination, you can help by
> working out under what conditions GMBUS fails. That info message is only
> generated after we write a message over GMBUS and receive no response.
It is logged at 15:32:07 on my machine, and at that time, the machine was
fully up with X/KDE/compiz running.
It is a laptop and xrandr reports :
Screen 0: minimum 320 x 200, current 1440 x 900, maximum 8192 x 8192
LVDS1 connected 1440x900+0+0 (normal left inverted right x axis y axis)
331mm x 207mm 1440x900       60.1*+
   1024x768       60.0 =20
   800x600        60.3     56.2 =20
   640x480        59.9 =20
VGA1 disconnected (normal left inverted right x axis y axis)
   1920x1080@60Hz   60.0 =20
DP1 disconnected (normal left inverted right x axis y axis)

But I'm used to work with a screen connected to VGA1, and I connect it
usually once my KDE session is started, and I activate it manually using
xrandr.

I just tried to repeat the process... but got another bug : activating the
second screen for the second time (after deactivating it) just resulted in
garbage on that screen. Primary (LVDS) is still ok, but VGA1 contains some
black area, and some part of the LVDS1 (though the resolution not being the
same makes it funny).

No GMBUS message again... Gotta have to reboot...

....

OK, rebooted, step by step :
1 - Boot : no message,
2 - Start my KDE session : no message
3 - Connect the screen on the VGA1 port : no message
4 - Let KDE Daemon prompt me a screen has been connected, and click
    Ignore : no message
5 - Run my second screen activation screen : got the message !

Here is what the script does :

MODE=3D1920x1080@60Hz
$XRANDR --output LVDS1 --primary
$XRANDR --newmode $MODE 172.80  1920 2040 2248 2576  1080 1081 1084 1118  -=
HSync +Vsync
$XRANDR --addmode VGA1 $MODE
$XRANDR --output VGA1 --mode $MODE --right-of LVDS1
$XRANDR --output LVDS1 --primary

> I've looked into one exchange that suggests that we may timeout if the
> monitor is disconnected. Do you have anything connected to what would be
> the first external output? Does the message go away if you boot with
> that connected/disconnected?

Only the LVDS1 connected at the time of the boot, but the message occured
later.

> > Should I report more details (and if so, which ones) or is that harmless
> > (though I doubt kernel messages about a time out are harmless ;)
>=20
> It's harmless in this case. Just a warning that the new hw driven method
> failed and we are now using the old CPU driven method.

OK, so I guess that me feeling the display is less responsive when
switching desktop is just a feeling.

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



--Sig_/0cUAX=0X6D4wGvhIXYC=BfR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk36JQIACgkQZP464AVDf+DDiQCfT6tDp89QWIlNQ+g1xp8J1/Wz
ssEAn08nSuCZK0ThEWLnzD4fZiCisnQX
=yH86
-----END PGP SIGNATURE-----

--Sig_/0cUAX=0X6D4wGvhIXYC=BfR--
