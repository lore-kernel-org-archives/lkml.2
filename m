Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab0G2IJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:09:47 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:46088 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab0G2IJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:09:43 -0400
Date: Thu, 29 Jul 2010 10:09:30 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Regression 2.6.35-rc6: ALSA Intel HDA/Realtek:
 missing	Beep
Message-ID: <20100729080930.GA20619@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
	alsa-devel@alsa-project.org
References: <20100728144903.GA18170@darkside.kls.lan>
 <s5hzkxbtya9.wl%tiwai@suse.de>
 <s5htynjtwz2.wl%tiwai@suse.de>
 <20100728212745.GA15394@darkside.kls.lan>
 <s5hd3u6alkp.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
In-Reply-To: <s5hd3u6alkp.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 29, 2010 at 07:44:38AM +0200, Takashi Iwai wrote:
> Mario 'BitKoenig' Holbe wrote:
> > But the BIOS itself beeps through the sound-card at boot :/
> But BIOS tells that the HD-audio codec shouldn't use, so the driver
> follows it.

Even grub's beep (play 480 440 1) goes through the sound-card. So it
seems like the BIOS leaves everything set up working as well.

Please don't get me wrong. I'm not saying the driver does something
wrong, I'm sure it doesn't. I'm just sure that if I could convince it to
behave as if it would have detected the Beep pin everything would work
fine again because it did before...

> Please give alsa-info.sh output instead of codec proc file.  It's more
> comprehensive.

Attached.

This is from a kernel with both patches applied you sent me.

> With the patch below, you'll likely have back the system beep sound.

Nope, no sound. But I guess this wasn't the intention of the patch. Now,
no beep input is registered anymore - which was the intention, I guess.

> But it doesn't go through codec, thus no volume control.

If you mean it should go through the 5V PC Speaker (i.e. pcspkr) - I
don't have such a thing connected. I always appreciated having volume-
and mute control over the beep at night when you can't get away from
work but don't like to wake up anybody just because command completion
beeps, because you pasted something in the wrong window, or whatever.


regards
   Mario
--=20
Independence Day: Fortunately, the alien computer operating system works ju=
st
fine with the laptop. This proves an important point which Apple enthusiasts
have known for years. While the evil empire of Microsoft may dominate the
computers of Earth people, more advanced life forms clearly prefer Macs.

--gBBFr7Ir9EOA20Yy
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="alsa-info.out.gz"
Content-Transfer-Encoding: base64

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

--gBBFr7Ir9EOA20Yy--

--WhfpMioaduB5tiZL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTFE3OhS+e2HeSPbpAQLAIgf/UhhTWPgp0VkNpZ86KjgTT1FhEVEcOJtZ
Nw+um6xaSUhVvGTTuslBXPZX1ERBWnm2hQEaWOt/Q+xTy4g+Q7Ke1/ZmV+75yejO
MeL+whvidmn1ZPa7KWf/bAGwjCLF7I5T60WA+Re4CUH6MW3XLCAVmvClONp94AMT
CXRkX0KUWSnht6Pcn3jEDzi//uJuTvnHC8ktxn2x2krYnLmzfU59gw+WfsRt3wcW
7ipgXiBo4akGC96PwOeM3VG5vxY2Hwn+XbdHHqTEeRvmPjDhhBqQwqbEMi56slUq
qDDwnkQUhu3X5pz2oUUYI0qvA4gL4clX4+ug1EQbxTybHM844Ru/Sg==
=2EGD
-----END PGP SIGNATURE-----

--WhfpMioaduB5tiZL--
