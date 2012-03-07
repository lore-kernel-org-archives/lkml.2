Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab2CGLsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:48:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55091 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378Ab2CGLsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:48:13 -0500
Date: Wed, 7 Mar 2012 11:48:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v6] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20120307114811.GF3107@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
 <20120229235147.GM8295@opensource.wolfsonmicro.com>
 <CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
 <20120302125819.GE3230@opensource.wolfsonmicro.com>
 <CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>
 <20120306100012.GC19635@opensource.wolfsonmicro.com>
 <CANKRQniUnEPawXZHcPH9kG0hDiaZ-eJ_vOQrCefB0ntCu98D6g@mail.gmail.com>
 <20120306121222.GK19635@opensource.wolfsonmicro.com>
 <CANKRQnjFB8G5iRKZLQok+qnQrPXf7vcRGto_OyL+1=VNBTnetw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yZnyZsPjQYjG7xG7"
Content-Disposition: inline
In-Reply-To: <CANKRQnjFB8G5iRKZLQok+qnQrPXf7vcRGto_OyL+1=VNBTnetw@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yZnyZsPjQYjG7xG7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2012 at 11:16:50AM +0900, Tomoya MORINAGA wrote:

> If possible, I want to use framework features. However, I judged it is
> not possible.
> Let me confirm again.
> As I said before, all ML26124 registers need to be accessed by
> different address when read and write.
> Like below
> R       W
> $00h $01h Sampling setting
> $02h $03h PLL setting
> ...

> Even so, can I use framework features ?

No, in which case (to repeat what I said previously) you need to make
the code *much* clearer so the reader can understand what it is doing
and why it's having to open code this stuff.

--yZnyZsPjQYjG7xG7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPV0r1AAoJEBus8iNuMP3dCJgP/iUhXHbBtDolB1kbZFedlcCV
gn2KsR9hS83o5pdCxN4W3uiq2crghU+qjOvgnVXTda+adbvf9g0CkSJsZbU2NtTA
lBuVZ1/hwghEmoQnnR2W5fG9iH6DMqNvmCreLutYAO4YIbKSJQ3+7iUk5OsXPq/+
5pLMoOr4vZkskxOalcHJHa4zOnziyYP7QlKy8H3xjm4RtqrNwYWplgRThdeEV/mC
SOX/oycMmYQyAecydsspz2Q40N2eBCaxG+ShlT8PmPJaxdMh9kKY8qVBW681bc7L
KvkC+vgXG90txof9L+Cmw+Wy/k/jG48InVdkVdw1ikRDDAN2YRsc6gZYZDrnNAwG
GHY85pFt2gLGG3yn00jfFNt9VesvoEhSoIX0l9+KmlCXhzlRGeJuMPNpHxC+hbiQ
bEKr0R2ZVHZmCkNYw46NAlqqZsI3wSpgJ0dNCMibuNMbM/GJQ2lJeHfk3l6cKF7R
zp05cuDWjKSSuOJKR1cIKjv+0p/z8Erz/aK5z7h/EKOap3Z6Qhflt40+Z3VJUswf
lToz/ro1c0VFANYvR7nxGmIy/t+0ZTVapyQQO9flihOnY/2SjCtuppWFRh6Tp94i
g5qkCjyycWX+GD1iSFOOCex6yjJEJjg3z2RrTMEPRxO3y9qH3C5b7u7MnTWbRZJP
lpII2OiNePLDO/qDq0M+
=tuK2
-----END PGP SIGNATURE-----

--yZnyZsPjQYjG7xG7--
