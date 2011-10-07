Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab1JGX3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 19:29:30 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33464 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1JGX31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 19:29:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg KH <greg@kroah.com>, "G, Manjunath Kondaiah" <manjugk@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] drivercore: add new error value for deferred probe
In-Reply-To: Your message of "Fri, 07 Oct 2011 16:12:45 MDT."
             <CACxGe6uOmrLwJSPw4JHuOmt5B2wsukdDgVUr01pryq5Z9BFadw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1317963790-29426-1-git-send-email-manjugk@ti.com> <1317963790-29426-2-git-send-email-manjugk@ti.com> <20111007064349.GD27508@kroah.com>
            <CACxGe6uOmrLwJSPw4JHuOmt5B2wsukdDgVUr01pryq5Z9BFadw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318030113_9306P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Oct 2011 19:28:33 -0400
Message-ID: <32004.1318030113@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E8F8B27.0011,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318030113_9306P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 07 Oct 2011 16:12:45 MDT, Grant Likely said:
> On Fri, Oct 7, 2011 at 12:43 AM, Greg KH <greg=40kroah.com> wrote:
> > On Fri, Oct 07, 2011 at 10:33:06AM +0500, G, Manjunath Kondaiah wrote=
:

> >> +=23define EPROBE_DEFER 517 =A0 =A0 /* restart probe again after som=
e time */
> >
> > Can we really do this?

> According to Arnd, yes this is okay.

> > =A0Isn't this some user/kernel api here?

> > What's wrong with just =22overloading=22 on top of an existing error =
code?
> > Surely one of the other 516 types could be used here, right?

> overloading makes it really hard to find the users at a later date.

Would proposing '=23define EPROBE_DEFER EAGAIN' be acceptable to everybod=
y? That
would allow overloading EAGAIN, but still make it easy to tell the usages=
 apart
if we need to separate them later...


--==_Exmh_1318030113_9306P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOj4shcC3lWbTT17ARAnNnAKDIOtuWic3rV/UGBFdp88UicSvhhQCg7T/R
kVC27cR2/6C01IaIf5qx7UE=
=QBeY
-----END PGP SIGNATURE-----

--==_Exmh_1318030113_9306P--

