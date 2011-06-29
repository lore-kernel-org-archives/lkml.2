Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab1F2Tle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:41:34 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:55818 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932098Ab1F2Tld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 15:41:33 -0400
Date: Wed, 29 Jun 2011 22:41:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] usb: gadget: add max_speed to usb_composite_driver
Message-ID: <20110629194126.GA6057@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309350899-23868-1-git-send-email-tlinder@codeaurora.org>
 <1309350899-23868-2-git-send-email-tlinder@codeaurora.org>
 <20110629123826.GQ2760@legolas.emea.dhcp.ti.com>
 <051801cc365a$73187140$594953c0$@org>
 <20110629124822.GS2760@legolas.emea.dhcp.ti.com>
 <055801cc3681$d080ba00$71822e00$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <055801cc3681$d080ba00$71822e00$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 29, 2011 at 08:27:17PM +0300, Tanya Brokhman wrote:
> > it might take a while for kernel.org to replicate things, maybe that's
> > why you didn't see before ;-)
> >=20
> > give it a few more minutes and check my gadget branch to see if it's
> > all good, I'm going to test it again on beagleboard to be sure nothing
> > is broken.
> >=20
>=20
> I went over the emails and all is ok. Thanks!
> One question: Greg/Alan mentioned that the compilation warning should be
> fixed by __maybe_unused. I wasn't aware such thing existed. Just looked it
> up.=20
> Do you want me to send you a patch that fixes that or have you done it
> already and I missed it again :) ?

Oops, I didn't. You can send a differential patch (just this change in
particular) and I'll merge into the original.

--=20
balbi

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC3/mAAoJEAv8Txj19kN1alIH/R9gazlIYr4pbncjiXCgtYpf
6F0iyBV9KHjj1Xf81Wt3M84nSnZdc0rz5oP2xtTlqeFG89lS1O2Gp0nHjq6PRot5
R9/Cebo1Y3WErq/p11l4Q+ftrZqfDvOW2DqvZ3Yw0ydsl2vzStneG7iinX2DpBaM
t5D5MxGDTkkt4/6V6kyZfSPstfSr4iclwyzgcC9naGZXqfrULBL8lWzSZJKro9IK
/N8mlC9oexzC4JTbX+bJFsRMJE2NNeg8AYgK0gISfyaCtwHDMn/MD+Z/6+wteMd3
L9pv6i9OUJE5V3gsJmuhJ9rTuJrhhjAC1wx7yr/qsRb5m2C8Bkw8OuToulyV7eo=
=FNw7
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
