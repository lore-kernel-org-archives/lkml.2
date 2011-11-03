Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1KCWC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:02:28 -0400
Received: from home.keithp.com ([63.227.221.253]:37764 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab1KCWC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:02:26 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 4/7] drm/i915: Let panel power sequencing hardware do its job
In-Reply-To: <20111103125708.476af3b6@jbarnes-desktop>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-5-git-send-email-keithp@keithp.com> <20111103125708.476af3b6@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 03 Nov 2011 15:01:35 -0700
Message-ID: <yunlirwrhkw.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Nov 2011 12:57:08 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Modulo what we already discussed on irc about the PP_READY bit, and the

Right, the PP_READY bit requires that everything needed for PCH eDP be
running, even when you're using a CPU connected eDP panel, and so it's
not actually useful.

> CodingStyle nitpicks (newlines before {?  come on, this isn't X :),

Ok, I can fix that at least, even if I think it's ugly in kernel style.

I'll clean up the style and attach your R-b.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrMPPzYtFsjWk68qAQi7QRAAjCjnDaNU2m7Z1s+UA7QxUwsWgW2k9ilB
6pgsUd0hKr4GUFjAmXHXAT9fBe0Uzrip3WyVBU5QXH+MPCXIWc5Hfm0dfBUhYAQB
O/S17rIryKLc8YYVPn5dsmLSDBjGjr9Q9u9ax9Q6hd6lR3SyYCEPkPgEHw/LLeuz
3Q7FjFF+v1krekUD3mU7mCbJk3dGT4BmufPC2ifGPmvIgvM3jgAVFrYdnv0qe+He
bN6el7ux6crxk0R0yqSFMlP185fC/abeam5nhsf8VuCgPTyE3enBTeP1R6tt4YRL
jPokEqnalPvrqQTljp41dtmSmD6WYRXc9qt0IgiTMaV7vEx1au/wNSoxvATbg0Pv
xf57H78TQxaxNqp1ux26TX3JiRcIYCIScZjxMS/Jk7FqkkM5Hhkn4whELrBTp4NS
TzfBmveTUB7DnmgcTB5JtFrTBCxEynCC6rxGVs7pAM0ePEve+R1X+nfbExXWgWGI
dWWBX9OsBIGNww8bZwmShzjM2kNFpbMjs2eOiL45nuaoaXiASDDtkOwVW3x6+kNa
3rI6siZXkY0HZ+RX5nKxQq163nKFifWwgXBJ1y4EfVMFh6MKrv/3CGTA0K9DzIhw
dbSkhZvkIUJDb43h9K7Gse64yovfdMedJcAgh1Jf5cFol7HtMrj/c+zbFhYlmZud
AmNxRoISf6E=
=AGoB
-----END PGP SIGNATURE-----
--=-=-=--
