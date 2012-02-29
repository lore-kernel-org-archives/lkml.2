Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2B2MjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:39:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51935 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757306Ab2B2Mi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:38:59 -0500
Date: Wed, 29 Feb 2012 12:35:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <20120229123511.GA7730@opensource.wolfsonmicro.com>
References: <CAJ0PZbRsh_Cnqy8Vtf1FWLajBr=R5iQ=Jog+w+qPE-uKrh5XQA@mail.gmail.com>
 <20120228164413.GA11021@kroah.com>
 <20120228165727.GO3683@opensource.wolfsonmicro.com>
 <20120228170246.GA11415@kroah.com>
 <20120228174505.GP3683@opensource.wolfsonmicro.com>
 <CAJ0PZbT=yD3SFBVYbcL37Dgyc3UVzk2LRQ_VWABW4cY_hfDuHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <CAJ0PZbT=yD3SFBVYbcL37Dgyc3UVzk2LRQ_VWABW4cY_hfDuHA@mail.gmail.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 29, 2012 at 11:05:39AM +0900, MyungJoo Ham wrote:
> On Wed, Feb 29, 2012 at 2:45 AM, Mark Brown

> > Don't know if anyone has a specific plan at the moment, though there's
> > enough people care that I'd imagine it'll happen if Android decides to
> > use this stuff.

> > That said I don't see this as a blocker myself - it's more like an
> > afternoon or whatever of work than a serious development effort to do
> > the updates, but a similar thing applies to most of the Android
> > userspace updates.

> I'm not sure which Android kernel devide drivers are going to be upstreamed.

There's a lot of things that are just generic functionality and aren't
at all Android specific, a lot of which is already upstream but just not
exporting the switch API but instead using other existing kernel APIs.

> However, if the swtich device driver writers decide to keep the
> functionality limited to the original Android switch class by not
> providing cable names additionally, the changes will probably be
> limited to ":s/switch/extcon/g" for API calls and struct name.

For things like headphone detection the actual switch they're providing
has issues too even just within the switch API - it's called "h2w" with
magic values.

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPThr8AAoJEBus8iNuMP3de9gQAJP5CzNNpai5tGU07XtVWcHP
90sdCEyQgFFz9hV/O8ckqF9WAGQZYjuKOuC/MnJZJI5H/jWOafDaIXcM180GoVCD
15Q+DilfwBPVLfgEWKysFhyngho2BD7fZN235B36LTj8YUY86fay+0YgIVR424SG
xyvjcyiQbw1LFqHDhXUA2/34m65vKnqTJfLer8R+3STopQkReu2doO4MnDHp0HZA
89VhcCmbXknBOHKQLui246ReJKo6T/U7lwE8EnFAauPaZ4V21FBeQq1BUEUdpNWA
Vy2AmE/B7dtfX5miQhs0hKlO3P7cVn2+UA6DtPwM18xSPMRI5xlb43lyx3YcewSh
HGO7CQEHLU4ehYhKyJyz52HOhub7GUY9RADwlSNTocJjXtFeaOKRwbIsCQ6K84nu
TOciQps9W08C+5t6DJDII3/0viu+UmpuWXxrQ5loed+iWV9lScny2FW+7U9D7aLw
Fe4WJMEZNhkM07acn1/4xW9zafBt45SnxkRNdDz/+vUsfy7+4Ev+xkmpokV6R1sx
N04eHXb7O6ZadJ6zX3JRd8Q1cduOLi6j42qc/b6pg05EoSuKfylWOYQFbbkLZF0y
CBjzMXs9LJSmrFlzTjITd4s1zTspvLLgXDRTgNKIZLci9dNLLxhK2M2SbtgU/7uw
djOGuyQuzIWf1HUFM8tm
=6V6p
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
