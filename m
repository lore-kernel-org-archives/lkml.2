Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab0G2NZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:25:42 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:55972 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab0G2NZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:25:41 -0400
Date: Thu, 29 Jul 2010 15:25:32 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Regression 2.6.35-rc6: ALSA Intel HDA/Realtek:
 missing	Beep
Message-ID: <20100729132532.GA18108@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
	alsa-devel@alsa-project.org
References: <s5hzkxbtya9.wl%tiwai@suse.de>
 <s5htynjtwz2.wl%tiwai@suse.de>
 <20100728212745.GA15394@darkside.kls.lan>
 <s5hd3u6alkp.wl%tiwai@suse.de>
 <20100729080930.GA20619@darkside.kls.lan>
 <s5h7hkeae35.wl%tiwai@suse.de>
 <20100729084138.GA15456@darkside.kls.lan>
 <s5h39v2acvf.wl%tiwai@suse.de>
 <20100729091517.GA8902@darkside.kls.lan>
 <s5hlj8utyi3.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <s5hlj8utyi3.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 29, 2010 at 11:42:44AM +0200, Takashi Iwai wrote:
> OK, then try the patch below (over my previous two patches).  It
> enables PC-beep for your device forcibly.

Yes, it does and it works. Thank you very much again.

I just checked 2 more boards - the P5E-VM HDMI (P5E-V HDMI's little
brother) is already covered by the quirk and P5Q-EM (G45) seems to
specify it correctly (subsystem_id =3D 0x104382fe - seems I got the logic
wrong before - LSB isn't set here and it works).


regards
   Mario
--=20
This project is so important we can't let things that are more important
interfere with it.
                 -- Advertising/Marketing manager, United Parcel Service

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTFGBTBS+e2HeSPbpAQIn1AgAlDzLaBjPNs0UCokOb1MvXiU8S1/R8fja
W2YLhHpSsm0c41O0M7lwVCGl2b6nsZe/tcfZlvFbReFUHBONg79clkDCxLnLHKR6
6YW/a4mTl8/U/ynzUIYqef7r/cLh7MWFyf0wKjbQVVwMM2nZmzKL5pfweDsSnzL8
Fd4qCPnRf6qn5dmcDR+JlZUgdceh5KQdjnJdHNg5pctS4uiZQaQcEm9wR/UVNEDx
B8M++ChfCO/id9OLd/Wt05aTwNvdz+zRGWQa78MSCejfvFSWvLvmF2H1QWyF0i0O
ZWHNxzEDh21+t9w0paDosP58S6fxJ0mg0tIiUinfNF+UmW55aMiadg==
=XC1W
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
