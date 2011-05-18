Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1ERKMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:12:14 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:38394 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620Ab1ERKMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:12:12 -0400
Date: Wed, 18 May 2011 13:12:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND v10 6/7] usb:gadget: Introduce
 usb_generate_ss_descriptors()
Message-ID: <20110518101201.GL11981@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305637403-3832-1-git-send-email-tlinder@codeaurora.org>
 <1305637403-3832-7-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+2GlJm56SCtLHYlr"
Content-Disposition: inline
In-Reply-To: <1305637403-3832-7-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+2GlJm56SCtLHYlr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 17, 2011 at 04:03:20PM +0300, Tatyana Brokhman wrote:
> This patch implements the usb_generate_ss_descriptors() function that is
> used to automatically generate SuperSpeed descriptors for gadget drivers
> that didn't provide any of their own. If a gadget driver wishes to have
> the SuperSpeed descriptors generated for it, it should set the
> function->generate_ss_desc flag to 1.
>=20
> This patch is not to be mainlined since in the long run we want all gadget
> drivers that wish to operate in SuperSpeed connection to provide their own
> SupeSpeed descriptors. The purpose of this patch is to assist developers
> in the early stages of their work.

if this is not to be applied, then you shouldn't put it in the middle of
the series as it's a bit misleading for people like Greg to filter the
patches :-)

--=20
balbi

--+2GlJm56SCtLHYlr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN05txAAoJEAv8Txj19kN1N4cH/1Mh638cmzNjAFyaeVPzBcFf
JTU3Rm/iowpg6lSmXpVHeSGB7NdAHGbsPHgkZc3DJ5uG104CQUg2vBIEHHOviERB
spwrsLVgv+pvTZKotCUsuQ+jebqXxSd3kT7mwNqnP+n2e7A+1nOgTejj6HMqYyUO
1IpBz5/T1xaRBbv4/tWWnCQQo8TUxrCo1T0s9AgGG4E6he7J/+u5VeJE9+KzNrJc
9NA11Dq3lyx5udfohTmuMuHxwULAlHweHcaKkUMq2YE91vT1mMsun09qu91Lggb4
7sNyOVM29C8Jdw8bqVJVhejSwHatg4V6aJkVcTQk2w3KFXxmwgankR2lZzuojI0=
=oEuG
-----END PGP SIGNATURE-----

--+2GlJm56SCtLHYlr--
