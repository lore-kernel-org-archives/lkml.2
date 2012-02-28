Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2B1Q5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:57:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60859 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752928Ab2B1Q5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:57:30 -0500
Date: Tue, 28 Feb 2012 16:57:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: myungjoo.ham@gmail.com, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PULL-REQUEST] EXTCON Patches (Re: [PATCH v6 0/5] Introduce
 External Connector Class (extcon))
Message-ID: <20120228165727.GO3683@opensource.wolfsonmicro.com>
References: <CAJ0PZbRsh_Cnqy8Vtf1FWLajBr=R5iQ=Jog+w+qPE-uKrh5XQA@mail.gmail.com>
 <20120228164413.GA11021@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vhqu5qQ3bjg0ZI9i"
Content-Disposition: inline
In-Reply-To: <20120228164413.GA11021@kroah.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vhqu5qQ3bjg0ZI9i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 28, 2012 at 08:44:13AM -0800, Greg KH wrote:

> Wait, please, before this code can be accepted, I would like to get
> verification that you have also made the needed changes to the Android
> userspace side of this interface, and that the code works there, and it
> is on its way to be included in the main Android repo.

> Is this true?  If not, what is the plans for this to happen?  Without
> that happening, I don't think this code can be accepted, do you?

There's a few more kernel changes needed there before full acceptance
would be possible - for example, should have an integration into the
audio stack as one of the uses of the switch API on Android is for
headset detection.

--Vhqu5qQ3bjg0ZI9i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTQdJAAoJEBus8iNuMP3dOzUP/iRJGuxzRgWrpodUAKPaqtzq
2Gl9M1KXFB40boWm1o9SwWTmpMGcecCTDum7NqP9r9a9U/ZlED6uRZgj53IdzI1F
HNzC+QaZaF+ZeGn0caR2cy/WnAP7vYlG2GIIyeHzxuoyWZ6RLvQqBxSsciq5AByC
YBxRgaxpM9yGe46vCdYf+nvP6j2fU+Fb/FCfngAwr5i2fqdl4Qm9YpBiw2Qk75+w
8zZsGLpE2j9pWOsXA1QvLBuc4fhDYjTLtQEdsaxBiV0nGc/rERv3Lzct43xeDIAr
ehzO/aIjfFc6EVRvh5qLxtdSnvlWshMa94UtVl9KlBHyRCvZeunkc5u3ymHVyC3Y
AEei/Uu8A9q5P4ngEzyc0IzgS6Xr1n1nAxgg0eLfx8vdKzcASTBkI9GNGs51JUFN
92nuoHjpGlUbBlfSnEoAZkqt7ttuw+gKPQ3JicCWuCCKfcOwYHb/fBrqcwgIfFtJ
crY2IBpR2xdhn/jj740nm5XZc8hPs+at5/IYXniSP3jgWC3A378igciottF/VFIC
GP/fyKH4FD8cvTdTgWdhYPV34sNU6hG7kBJ4HMyXU4oP5kbIzvJr+EejZ+9NLnJv
EL+NNBF58On7TIC5Hc3eRbjn95RBCVhNfjxrYdKt8K+V3bct6lsfFg12hzYBo4/s
15hdx3rvy2w5pTr702gJ
=36XD
-----END PGP SIGNATURE-----

--Vhqu5qQ3bjg0ZI9i--
