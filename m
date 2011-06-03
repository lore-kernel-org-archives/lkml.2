Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab1FCRhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:37:00 -0400
Received: from home.keithp.com ([63.227.221.253]:38796 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab1FCRg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:36:59 -0400
From: Keith Packard <keithp@keithp.com>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>, linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org, greg@kroah.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH]remove warning for drivers/gpu/drm/i915/intel_ringbuffer.c
In-Reply-To: <20110603130502.GA5740@gmail.com>
References: <20110603130502.GA5740@gmail.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 03 Jun 2011 10:36:55 -0700
Message-ID: <yunei3arf48.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Jun 2011 21:09:39 +0800, Harry Wei <jiaweiwei.xiyou@gmail.com> wr=
ote:

(process:18294): gmime-CRITICAL **: g_mime_stream_filter_add: assertion `GM=
IME_IS_FILTER (filter)' failed
> From: Harry Wei <harryxiyou@gmail.com>
> When i compile kernel, it shows me two warnings
> like below, so this patch can fix them.

This fix is already upstream; it wasn't included in the stable patch
as it wasn't 'necessary' to fix the bug which is causing the warning
(which ended up removing the last use of this function).

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN6Ru3Qp8BWwlsTdMRAkGhAJ95hTk9Rg3aczi5JJVxtQI3rFRTBQCgumro
ltVfd9QS6u18XyzwI6i5RXg=
=6Zk5
-----END PGP SIGNATURE-----
--=-=-=--
