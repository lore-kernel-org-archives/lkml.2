Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1I0SMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:12:01 -0400
Received: from home.keithp.com ([63.227.221.253]:46151 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab1I0SMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:12:00 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 9/9] drm/i915: Initialize PCH refclks at modeset init time
In-Reply-To: <e0d58a$1mfht8@orsmga002.jf.intel.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <1317103906-4649-10-git-send-email-keithp@keithp.com> <e0d58a$1mfht8@orsmga002.jf.intel.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 27 Sep 2011 11:11:57 -0700
Message-ID: <yunoby597o2.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 17:56:39 +0100, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:

> Ah, now I see why we moved from using the active configuration earlier. ;=
-)

My evil plan is revealed!

> Doesn't this prevent us from ever using SSC though, as virtually every
> single PCH machine has HDMI encoders that haven't been masked out through
> the chicken fuses or VBT?

That wasn't my intent -- the SSC source gets modulated whenever the VBT
table says it can, so when the panel uses the SSC source, it will get
SSC. Did I mess something up here? Or is it just some interaction with
the mode setting code that I didn't get right?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOghHtQp8BWwlsTdMRAtqTAKDAgK7OGqk2liAk6Elxd+MHT95bMQCfTu8N
ovPSP6YFvZ+x+Q7MY7cjwBQ=
=PKQ9
-----END PGP SIGNATURE-----
--=-=-=--
