Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab1KQVAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:00:41 -0500
Received: from home.keithp.com ([63.227.221.253]:43641 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab1KQVAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:00:40 -0500
From: Keith Packard <keithp@keithp.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Alex Davis <alex14641@yahoo.com>, Kamal Mostafa <kamal@canonical.com>,
        mjg@redhat.com
Subject: Re: [PATCH] drm/i915: Fix inconsistent backlight level during disabled
In-Reply-To: <s5hboscpexg.wl%tiwai@suse.de>
References: <s5hboscpexg.wl%tiwai@suse.de>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 17 Nov 2011 13:00:35 -0800
Message-ID: <yund3cqcvm4.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Nov 2011 10:58:03 +0100, Takashi Iwai <tiwai@suse.de> wrote:

> When the brightness property is inquired while the backlight is disabled,
> the driver returns a wrong value (zero) because it probes the value after
> the backlight was turned off.  This caused a black screen even after the
> backlight is enabled again.  It should return the internal backlight_level
> instead, so that it won't be influenced by the backlight-enable state.

Yes, this looks correct by inspection to me. I'll stick it into
drm-intel-fixes.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsV18zYtFsjWk68qAQh1NQ//b3ismcOe+N0TO/bgpa+XwFXnGxrMvbGh
ps65xMaMoyQwTT84cn+lr065Bp9rGTzVStnpT0wXHEcRCyPmDJ4cHXiOcFTvt8bF
JBMgn9ffi9f/3P5MW162J1NfcFGWhYtEL0KFvDrAzr8VtrrTH9suGhqXJF2ciYjA
X0liAXlJQCX2cArwh0nH15PkCKQIh1iNwfBGKAbyUPf3pqdko0Qr39I7lwiCmcLe
wuChDY8ueioMP7aCrwKAyDvEgbTTlMCKd6/RSRdylzO4A3BlEvHxTMwFmh0i1810
mTE96cQZyQuCPQDtpwaghgRb2ARCYtrnnhs5i5LYj7CZr6Oeo/UUzKz7jQrwmoOT
zJdjqt5i9b+E2Q48JtCjfgeg4AKbtyp4wSiD7hrMlAmngAh52Yl8d81y+kwpPpaf
fc4hL4f6u6kqwNlAyU0iDWv3I4lXfHyzqC4S87+0e2/sS2nGtB1pmbKy+qym2xt8
fplDVm63zNwbp0AHV1wHE/m5VVEv89HOPcWbfBDIPuPwqicoiMJ4HzkbNWqsci99
HRiEM3PeNifK7BJxV5Jr8IZ643ZdXaAgWyyxWlk3RDUPzki3Au0Dw0TocVrLYjvH
/vRh/310BzoxCfewuMuFHMmJ+EeNRbY5ivtpJrjixob/oGcou+yc5zoRHiyyueAd
iILGMuQNNDA=
=vinB
-----END PGP SIGNATURE-----
--=-=-=--
