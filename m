Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab1KBRPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:15:00 -0400
Received: from home.keithp.com ([63.227.221.253]:49584 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120Ab1KBRO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:14:58 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 4/7] drm/i915: Let panel power sequencing hardware do its job
In-Reply-To: <20111102092310.2177a339@jbarnes-desktop>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-5-git-send-email-keithp@keithp.com> <yunwrbjvv37.fsf@aiko.keithp.com> <20111102092310.2177a339@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 10:14:54 -0700
Message-ID: <yunlirywinl.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Nov 2011 09:23:10 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Note that PP_READY will incorrectly depend on some other register
> values, so in some configs the panel will happily power up even if
> PP_READY isn't set yet...

Yeah, I'd like to understand why PP_READY isn't getting set; we should
have all of the other pieces ready before we turn on the panel. But,
given that it's really just a sanity check, it probably doesn't make
sense to spin for 5 seconds waiting for a bit to turn on that won't.

I've just removed that bit from the IDLE_ON_MASK and IDLE_ON_VALUE.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrF6jzYtFsjWk68qAQixexAA3OhtgfAVDIgN9ZzkKeaaDC6eC7ONtFXs
tiZ5OjOc2Z1nLxZKTXnqpjyVyAQk+s1WNkjjJx4XsvbaUOtcp9hSLxnQjfX0vP3d
XNmJcnW67KtpaYJrcBOQhQEew1Ua+g2831UYK4K3F2nrw3eiUeb4Sw5+Q+SwplRd
XSGuJDlVofvDQt5fCmv4nkSqPesETzU4s8xzErk0VMILZ+tWta+0rHOO1ttMxr6N
3H7NviVrBzGHLEblMv5vTmb1sI7cnES7h/M8B0ayguEUZ/4DqzPH/CZ4U7OsboCc
eTVNf7LZUeaN4Nlrc0f4aF4zAXpSgntdw9TB+uuSNCwNpR5BT0j7OQ+3BNuxZvt3
efjYV8J1Y/SnDdS9DuDApNMiFIaHY73xD94E3j3WzznZjSqFMVnycBMPB2TRuhj3
sUSurPlPZmt1PC4BloepbCEAhNE2EkPxsae0da+q7qYhUQFqxXDIxPLfc3KH7wte
bHduA+w79lKmtPsO3SAeB8ZteaTVw8p1T7GtvLnSKEttrAT9mjCOr3aGcTF3GRbl
j1mEeBLn4B3D1xbSIWJIAA7tw5DUvdarG2hoj3EyLikMRochKRTMXmdohdSLyJ6F
hyb29E7Eejsfb53oD/1ycxB/Mxz05nmNAidTRU4t0OCPx9mX683/wNpNfR6oGgaT
dyvDSqsa39A=
=ocNB
-----END PGP SIGNATURE-----
--=-=-=--
