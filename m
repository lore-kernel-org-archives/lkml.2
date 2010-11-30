Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab0K3Vjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:39:48 -0500
Received: from gold.linx.net ([195.66.232.40]:35490 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0K3Vjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:39:46 -0500
Subject: Re: [alsa-devel] CONFIG_SND_HDA_INTEL regression on 2.6.37-rc3 -
 no audio
From: Tony Vroon <tony@linx.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=ywUP8QUDGqotutccf9E2a1b5U2bKNZDWa3PG3@mail.gmail.com>
References: <AANLkTi=ywUP8QUDGqotutccf9E2a1b5U2bKNZDWa3PG3@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/ltTDjWovEf0ykWzYI29"
Organization: London Internet Exchange (LINX; AS5459)
Date: Tue, 30 Nov 2010 21:39:57 +0000
Message-ID: <1291153197.4814.11.camel@amalthea>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/ltTDjWovEf0ykWzYI29
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-11-30 at 13:31 -0800, Luis R. Rodriguez wrote:
> snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,thinkp=
ad_acpi,snd_rawmidi,snd_seq,snd_timer,snd_seq_device

Note that on some ThinkPads, there is an additional output mixer that is
not always exported to ALSA. Please make sure that your hardware volume
is unmuted and at a reasonable volume.

Could you use alsa-info.sh to gather your codec files, system DMI, etc
please?

(The only audio regression in 2.6.37 that I'm aware of was Realtek
ALC269-related and has already been fixed. It left me without volume
control until -rc3)

Regards,
--=20
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net

--=-/ltTDjWovEf0ykWzYI29
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkz1by0ACgkQp5vW4rUFj5pyewCZAab9sC1OFx/H2GHL3yjhp8Of
D6wAoL2V8SVCaC2PcLKXotUkFSoFWjuo
=JpBt
-----END PGP SIGNATURE-----

--=-/ltTDjWovEf0ykWzYI29--

