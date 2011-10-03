Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab1JCXjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:39:54 -0400
Received: from home.keithp.com ([63.227.221.253]:33539 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab1JCXjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:39:52 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Paulo Zanoni <przanoni@gmail.com>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] PCH reference clock cleanups
In-Reply-To: <20111003162108.07c6b9bb@jbarnes-desktop>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <CA+gsUGTZfxt2L9mT-kYGGKiYhtRKn2xO5tXperwAWLVi2mKeOQ@mail.gmail.com> <20111003141423.0ff5447c@jbarnes-desktop> <yun7h4lmzon.fsf@aiko.keithp.com> <20111003162108.07c6b9bb@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 03 Oct 2011 16:39:48 -0700
Message-ID: <yun1uutmypn.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Oct 2011 16:21:08 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Agreed; fortunately shutting everything off when no outputs are
> active should be simpler than trying flip the bits on & off every mode
> set. :)

We'd have to track when outputs are shut off; just tracking per clock
doesn't seem any harder. I'll expect a patch in the morning, ok?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTopHxDYtFsjWk68qAQiYtA//fkzpnPdvyve2Aubssort4z/pgyWtr8yO
CZby+YXFRHNXTYMuNEG7VSsvHl+fqsc3+Q71Asl5tszIVFx91f6lfuAIf1ybdx4a
jkKbvzrs9eKSCwQ+xxMaRSdcRMwaXHIx0BUv9ichvroZfvviI+bTjxsTeB/Vlxgt
F72tGovl1Bgf3NHxzzbrJabTp4QIkjNVoSHm4gfW/E9Q/BUyXfaqyZpkr/rE4ktg
6oV4ssCVjS39cYXniv6xebETbPA3nUafLn8vGbDFuO9Rb+ALZSZORfFGi+qmDXkI
cA3yQ+Rt03r4UojWie8zE01UOqz59wr4f9Ik4jEqec4IAhziXR4R5x2flSTzzRsE
u/3YumUQ3Ro1zENDRGdl+eVWGMihzI+35bpV0Qdg0V/jfyY6tquH4xlLy1ecBG7K
dyPmEzmE+8PfBX9O+MMF0oSDW5W66oEPauJliOFmeBKo0Xg32DCkD6pVwaxwE8i9
KwzfAH0RLfpMwVk9aeJfk1a1DYmaFdDFGgQWVkwMZpKx4K972wypHCqCkFMa3Jjz
isPFKGUM3xcO9wBS+yber8Qsrb4cNiLCyBdsDGzNmWFRpIlnORzQwo4VZRBtEQ3P
Cy08MdUh1j1GWV7dXnFDUCDDCD7HPNBnpHMK2IsyEvUo4yng8qtBUbS5RvRaBKVh
Y//q+M2pQ2w=
=mvg6
-----END PGP SIGNATURE-----
--=-=-=--
