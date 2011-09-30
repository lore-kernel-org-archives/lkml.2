Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab1I3Sbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:31:52 -0400
Received: from home.keithp.com ([63.227.221.253]:47221 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab1I3Sbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:31:51 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 13/21] drm/i915: Place long delays after each eDP VDD operation
In-Reply-To: <20110930180111.GO2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-14-git-send-email-keithp@keithp.com> <20110930180111.GO2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 11:31:48 -0700
Message-ID: <yunehyx7ugb.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 20:01:11 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> Looks like a patch useful for fixing up this mess, but I don't quite see
> the point of merging this given that you fix things for real in the next
> one ...

Good point. In the development process, this was the patch which made
things work, so it's purely an artifact of that. I'll merge this with
the subsequent patch.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhgsUQp8BWwlsTdMRAsdFAKDBhfP9Ycj+HoXQf9tEhHCXv6XzQACeLNo0
02uLiIM7V/77q3ppd6tmJOA=
=yRbk
-----END PGP SIGNATURE-----
--=-=-=--
