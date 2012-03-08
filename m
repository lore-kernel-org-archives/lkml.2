Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2CHLFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:05:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42110 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754355Ab2CHLFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:05:51 -0500
Date: Thu, 8 Mar 2012 11:05:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v3] sound/soc/lapis: add platform driver for ML7213
Message-ID: <20120308110548.GG3638@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
 <1329976011-2251-2-git-send-email-tomoya.rohm@gmail.com>
 <20120302163915.GD6056@opensource.wolfsonmicro.com>
 <CANKRQni8hPoHEsV2VecbgKBdfS5+rit0-jXzz_d8F_nY5-dN3g@mail.gmail.com>
 <20120306115246.GD19635@opensource.wolfsonmicro.com>
 <CANKRQngg+8LJvb-+Byv6XPqqWFyCU1U+-hppuxo_=CM1qLUF_Q@mail.gmail.com>
 <20120307114631.GE3107@opensource.wolfsonmicro.com>
 <CANKRQnh2x-EYyaiOaz58zBeAe7PKWNS6cE+yyha5jSvignigHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TmwHKJoIRFM7Mu/A"
Content-Disposition: inline
In-Reply-To: <CANKRQnh2x-EYyaiOaz58zBeAe7PKWNS6cE+yyha5jSvignigHw@mail.gmail.com>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TmwHKJoIRFM7Mu/A
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 08, 2012 at 11:06:47AM +0900, Tomoya MORINAGA wrote:
> On Wed, Mar 7, 2012 at 8:46 PM, Mark Brown

> > You've still not explained the problem you're seeing but this sounds
> > like something that should work. =A0Please address the

> * Faced problem if there are no platform settings.
> machine driver's hw_params is not called
> platform_driver's functions(snd_pcm_ops, snd_soc_platform_driver) are
> not called.

> As a result, the following message is not showed . (by soc_pcm.c)
> printk(KERN_INFO "asoc: %s <-> %s mapping ok\n", codec_dai->name,
>          cpu_dai->name);

This makes no sense.  Registering a platform device will have *no*
impact on ASoC, it only cares if the relevant ASoC function drivers have
come up.  Probably there was some other problem with what you were doing
but it's hard to say...

> I can understand your concern.
> Let me clarify your think.
> You think that interrupt handler must check whether ALSA initialization h=
as
> already finished or not before interrupt process executes.
> Right?

Or it should be safe to run even in the card has not come up yet, either
way is fine.

--TmwHKJoIRFM7Mu/A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWJKGAAoJEBus8iNuMP3dcFUP/AhjPC3KkXsflquAimYtGQkX
83wSaKoZEzzEcKpxHk37GAUzuJmmXCw0kVkIubrGm49ptvWNYM5j7u0bleYhnznA
NGD1ivdh1funyk0jVkbKWleXArj+Ug/mxPCetwDxvF9cX7S6EBtCmxUo5ITOft2f
CRY0RVQ/ZyfSIHEyxv8+PE/42a+QONc94YZOv4btYfEAY0nIb0M9kua0AJGKwF0C
KeRhJavz7bDboDbJRPJieSTNzB+zyI6E714+mQrrg3Eb1CgGunL/iLlasF3tMJIL
DCVLkVM7N29ZDgBf98eFk99eNpzInYBvSt9e7JA4prvEBskAclLWICItJzOsCNuD
R7WCgPJxJKt8eFc0SZ0SVEPgNOag/47d/7KGG//vo7B+9PU1/J3NFvI3w/PBUOIw
L3fSp488xj6umNcoA1y0CFAfZ0S8bCWHPJoBfrDnIogaTgFqimkw8AeUDQUjE84S
qk3VXb/0de/8VtKlmLe5ESfGc3mafhP91M79orSUX8CYN4pTLbTUeeWFNTdXE/Cd
rSTZWOe74uRgkp+CcTgy580sDiVzQlJz+Sz3KTQAMiRyDpdbqeiKdAE+A/U72l8g
G0NAYKhh7hM4sFkILhke9rALAglDqGC/Cf+PkafLhpIa87khUlAeL/Ij5N2YmTly
XoeH3MJh3xkfCnmij7+8
=r798
-----END PGP SIGNATURE-----

--TmwHKJoIRFM7Mu/A--
