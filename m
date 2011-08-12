Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1HLOOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 10:14:22 -0400
Received: from home.keithp.com ([63.227.221.253]:60406 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab1HLOOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 10:14:21 -0400
From: Keith Packard <keithp@keithp.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@linux.ie
Subject: Re: i915 suspend crash: BUG: unable to handle kernel NULL pointer deferrence
In-Reply-To: <4E44C537.8040101@gmail.com>
References: <4E44C537.8040101@gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 12 Aug 2011 07:14:17 -0700
Message-ID: <yunobzusona.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Aug 2011 23:16:23 -0700, "Justin P. Mattock" <justinmattock@gmai=
l.com> wrote:

> I can try for a bisect, but might not be able to do so due to time=20
> constraints and things.
> (if there is any patches to try and test let me know!)

Can you provide the output of 'lspci -n -v', and can you tell us which
version of the kernel this corresponds to?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFORTU5Qp8BWwlsTdMRAo0tAKDOv0PniALL9zbu2mcuueKks7ez1QCdHD3D
+Q9g+EHQ8NneHm5yCLjBQQg=
=gIeq
-----END PGP SIGNATURE-----
--=-=-=--
