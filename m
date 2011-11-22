Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab1KVRye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:54:34 -0500
Received: from home.keithp.com ([63.227.221.253]:59473 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab1KVRyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:54:32 -0500
From: Keith Packard <keithp@keithp.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, harald@redhat.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Fix invalid backpanel values for GEN3 or older chips
In-Reply-To: <CACTFLAOyA1XiPxstviwfbjAuTXSpKq-CEJ5FBRtFDhaKb8yk1A@mail.gmail.com>
References: <s5hlirgm1kg.wl%tiwai@suse.de> <yunsjlnl1f6.fsf@aiko.keithp.com> <s5hlirelndd.wl%tiwai@suse.de> <861ut5mdvn.fsf@sumi.keithp.com> <s5hr5144ecu.wl%tiwai@suse.de> <867h2wklln.fsf@sumi.keithp.com> <s5hd3cn3unp.wl%tiwai@suse.de> <86zkfpgxcx.fsf@sumi.keithp.com> <CACTFLAOyA1XiPxstviwfbjAuTXSpKq-CEJ5FBRtFDhaKb8yk1A@mail.gmail.com>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 22 Nov 2011 09:54:29 -0800
Message-ID: <86y5v8f3fu.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Nov 2011 17:40:25 +0100, Daniel Mack <zonque@gmail.com> wrote:

> Just curious - is this patch queued somewhere for mainline yet?

I'm waiting for airlied to pull drm-fixes-intel before I push more stuff
there.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsvh1TYtFsjWk68qAQhYlQ//ahAWF190DPRTBzRG9k7ViZX60T9FnrwM
NwR7p4eoEG9lWA88DLckyyh4ZxiztB/cdgyGDCwWfRWnXVkCU866Qr0XoVku3m1r
eUDpDDAtr3Pu3r6SgHbP6dEDt0mfcULD9HpbybQ93OTuMdFfw7pGo3umnLWC93wa
+yQ/ROvEWh4Fi+2X/zVEAMt9Az2sV4bZrH8ox+LjVR5pstC/76ec4U2Z1boUzNpD
PDoz30ZixA453HUVqJ9wUTObLuqU7BQtgqlJXwwuAVULp4IMYlX4zphbMw4tH0PW
JEEANMZziN3x17UgMqFBe6vJQLkcot4DtLEdHMq0oBra40vtRcFYk6Au/tyuo3+S
YNvrLESf3ZW14cQcEJdSNgPvDhrojIV1I4RPvEgLF1WH51M88Htc4+QkNl7pIQrz
BtLK7M7qI3kIScxaQhxGs0+mFH3mPCSsv5Z7nou8ZB18YgrGcTFezkceOv4WxiPo
nYL70dZcEdW3Atv199SrmRREr2Lhw89vmFmN1HG5MgGCeTBeLvDV5RY9XH6bzIrn
PJh6oe7Ikewlt+7TJUGIGcMYQrI1goGlB3s8Iq3d684/TMoszcQvkKAz9Qf+pmaF
w64b/YkDhGQteP7DT1BtT/dIBs2y+0mhj1/2jrKeauOghgRk+14AuAbHarh64LNX
rH+HwTOLeSU=
=Qq2T
-----END PGP SIGNATURE-----
--=-=-=--
