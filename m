Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290Ab2CNRpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:45:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38389 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761145Ab2CNRpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:45:21 -0400
Date: Wed, 14 Mar 2012 17:45:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, alsa-devel@alsa-project.org,
        qi.wang@intel.com, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com,
        kok.howg.ewe@intel.com, Liam Girdwood <lrg@ti.com>,
        joel.clark@intel.com
Subject: Re: [alsa-devel] [PATCH v6] sound/soc/codecs: add LAPIS
 Semiconductor ML26124
Message-ID: <20120314174518.GV3133@opensource.wolfsonmicro.com>
References: <CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
 <20120302125819.GE3230@opensource.wolfsonmicro.com>
 <CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>
 <20120306100012.GC19635@opensource.wolfsonmicro.com>
 <CANKRQniUnEPawXZHcPH9kG0hDiaZ-eJ_vOQrCefB0ntCu98D6g@mail.gmail.com>
 <20120306121222.GK19635@opensource.wolfsonmicro.com>
 <CANKRQnjFB8G5iRKZLQok+qnQrPXf7vcRGto_OyL+1=VNBTnetw@mail.gmail.com>
 <20120307114811.GF3107@opensource.wolfsonmicro.com>
 <CANKRQnh2JqhZBYLP=U_isgthh2pFT89_qBeypda1ciUJzoRXYw@mail.gmail.com>
 <4F60D804.30804@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZUxj+kVYsk1YKJSS"
Content-Disposition: inline
In-Reply-To: <4F60D804.30804@metafoo.de>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZUxj+kVYsk1YKJSS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 14, 2012 at 06:40:20PM +0100, Lars-Peter Clausen wrote:

> If this is for all registers, how does stuff like DAPM work, which uses the
> framework internal update_bits function?

I was assuming that this was just for specific registers which were
weird (frankly I've no idea what the chip designers were thinking if
this is actually needed).

Though based on some of the issues I found on previous versions there's
every chance that there's not been any testing...  if that's the case
it's possible this is a misunderstanding of the I2C read/write handling
with the chip address?

--ZUxj+kVYsk1YKJSS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYNknAAoJEBus8iNuMP3d2vgP/jhn2e0LB6ofGvFXjy1KxyK1
jgMski1XZi2xR2PtXu654e10fR7u4Tl5InaMXTSjKHOv0ubWVqFGJP20zBd8K0XD
SL5VkaPE1CZrmLDoNdy9AMzxmW8jxN1ZuMPW9jLm39er2ntcvS5yA/IWpMRKesHu
dNhiDT+XlqJ4+GxNO7SjleEfct36WEDsJv21w0XWFHMvjbmZ5cCxNcAYLEbJkWsq
h99dPtl23272F5E9crshR9DqfOBXxzYvI2o+suFJXVLk3Wz5azYqfMlGbpElc/N5
iri7InICjfJGgC54g8xKQMU5jA4BbvdGFmlcNDn8swelaVKMoL18YL4OoIzJhBGb
W1+f5AkJDdFQGN0dFdIaNzJNO+PdbOxIvbKqZM3c5AUxF0lh9liblKHKSMoFuzt4
soIdYMNvbQXMYcQlbJHJ4+c0ARPhlRg5iK1S48LVCd9qnH8Mz+JJZPV7iB96b/oA
Y4jgQiZOqfLlZh1X6wolCJl3LgtGTq7Ivr1xwDe7BsPoKNysjiS0eIqIubzeCqzM
giVeRsooToEzubXxbRDdFe/6ofqaoFN1rzKG6Ei+VZCGPOn0z2kV738V4j4TFcqS
rVKWo/V6HejqbM759aNnYLenigF3817kEMz5XzncyZ+xKAKRPHtVZ7o5C5NGBxGN
FDYkO45EhRU8PiuPfcLX
=0iQb
-----END PGP SIGNATURE-----

--ZUxj+kVYsk1YKJSS--
