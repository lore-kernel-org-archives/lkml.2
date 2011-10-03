Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab1JCXSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:18:53 -0400
Received: from home.keithp.com ([63.227.221.253]:35827 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab1JCXSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:18:52 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Paulo Zanoni <przanoni@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] PCH reference clock cleanups
In-Reply-To: <20111003141423.0ff5447c@jbarnes-desktop>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <CA+gsUGTZfxt2L9mT-kYGGKiYhtRKn2xO5tXperwAWLVi2mKeOQ@mail.gmail.com> <20111003141423.0ff5447c@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 03 Oct 2011 16:18:48 -0700
Message-ID: <yun7h4lmzon.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Oct 2011 14:14:23 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Now... is keeping the various refclks enabled costing us any power?
> IOW, should we be trying to disable them when everything has been
> DPMS'd off too?

That's the same as tracking usage and enabling/disabling on the fly as
modes are set. I think it's possible, but I'd like to have the 'simpler'
fix present before we try a power saving move.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTopC2DYtFsjWk68qAQimLQ//XJMg+c3g2OuTNeUfEsZoU4oXluzXvz12
TS2VN+EtWYuI86wYFksKmKtJEKEEIqjjRMAcpqQu2BrUz/mz0xOIaQtmuFgJ3PUY
cd1IIqAN126m0CLyi4jLuTsbqgO2AzYGmNAgWdquAWs2RQjXh+MkgjAwtkfX+eO1
Q/UaKHyJgRQRaFJIxwM0AF8AjBQzdcTtc6RDDc7BVAkBBER0lUubBN8jjuvdaqq9
cJZHVYO0LuhCrnjYoMH34yBnK5Uk//eUgsbQDPdmFhwWoXumBW6vXg+AdnW9+KeN
Ou4C/Bi1lUgSx4t9NHEbF1B0GamcyUeoWY6xc8fGtt0iLnTkUnSUkw9n84AF25Gw
2e+TRPc/dy8lv2S6jQDgH4vwNx9Zh7/Vn2DHJaNPlIUnW1J8bA1n3ohhn5cmZrVm
9ZO1+Y4sTUENO7/R+v/W/Lcl/u3KLIpyXWFO4o07gIUy1UVhsAOpKo3K56EsfRdp
M8BIDZqbqIpOli8hTsLkCwyoXlsIf0Ok8a/bbLd5wmA6XFEXmvajpg3YxGMmcXBH
7ngcJyulnLzMYh/CRoMfjyArIaTxqIqXDJVc6T52aVYxHs91Y3qjBGbB/3xRxBN0
G8EN9AUsISoM/WG81Y33eqOt3LMfNj2rA9q/64y1IY3u/AFA/04eOEY08IuTY2PV
MAN8bpI65kk=
=Fi4T
-----END PGP SIGNATURE-----
--=-=-=--
