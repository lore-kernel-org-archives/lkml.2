Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab1KAS3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:29:51 -0400
Received: from home.keithp.com ([63.227.221.253]:59540 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1KAS3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:29:50 -0400
From: Keith Packard <keithp@keithp.com>
To: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: Re: [PATCH] drm/i915: Fix object refcount leak on mmappable size limit error path.
In-Reply-To: <87pqhb232g.fsf@eliezer.anholt.net>
References: <1320128181-3161-1-git-send-email-eric@anholt.net> <yunsjm8pbvy.fsf@aiko.keithp.com> <87pqhb232g.fsf@eliezer.anholt.net>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 01 Nov 2011 11:29:47 -0700
Message-ID: <yunk47j1ysk.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 01 Nov 2011 09:57:27 -0700, Eric Anholt <eric@anholt.net> wrote:

> I went ahead and finished the read-through, and everything else looks
> good.

Thanks. I've merged your patch locally; it's on top of a couple of
patches that need some work, so I'll reorder stuff and push this out today.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrA6mzYtFsjWk68qAQhygQ//S9WCYXniscjxN5ehVc9tf6g83fLYZhIx
lwPWJO4FLukeYLi2/o+J/gFHlw95ilpNlmGHZ60VBIOhfYIOw25Qd3hzTKuTVOPk
KoDmUTv+sk/3Q6Apf49dmQTBFBYBUtzeRWxArzEFmeP9FdREATYY1nzOv0a2RY2i
3dwgHkLWwZ3q3FA8tvI+zjYYUO20+oLV5zoV1r/04nLoKFaMh6MCtU8wNnuhAMxM
EtPlf8g+GBWSFEAh2TrCoxDgNvhAbQ6aA/tYPwSqYcGl7MctfyuJAjMFDuaF5ewx
+B+XiigtUZOokygx1lIvTSi76hT3xAXISf3ZNkBLkGnlCMh0FEEAq82Yk/wtwFZl
HV6y/UqZGZZrJ/Cu6VoEfohz3U0hURcxFti34MpOSrbhmpWNS4swVdx6IU0qBRTx
8hOUcgMohpNe6xoJwm8OFqUBcnxIbQXtreCTPOkfIfGG10pI7q+AtmalaUIeED8S
VhQ4Oq6lwBE4qNMa7U+KNWujzbSyMmCVMN5lZPh0BbpGafrlotmSEqIMzphlrYJX
/zuNRf80aBTCohGFNaPZ/r/9iZSo+fB/74BiVwbvknhSTkgVJcU//c4r0hTVbks3
AKkd9dXj00a8WfaHdq1R7xvo6mvY1hci1GutlD/blkZ3Nwj0+3GNsgYpKn5zPULy
HIgvVf2AeCg=
=bZ3e
-----END PGP SIGNATURE-----
--=-=-=--
