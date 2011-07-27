Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1G0JwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:52:04 -0400
Received: from home.keithp.com ([63.227.221.253]:33783 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab1G0JwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:52:01 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm pull for -rc1
In-Reply-To: <alpine.DEB.2.00.1107261254260.29862@skynet.skynet.ie>
References: <alpine.DEB.2.00.1107261254260.29862@skynet.skynet.ie>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 27 Jul 2011 02:51:50 -0700
Message-ID: <yunvcuokq4p.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Jul 2011 13:02:35 +0100 (IST), Dave Airlie <airlied@linux.ie> wr=
ote:

> (and btw I know Keith has a lot of fixes into next merges, its hard to=20
> balance the requirement about not merging with the fact his QA team need=
=20
> to test merged trees and I want to pull what the QA team has tested).

Yeah, sorry 'bout that -- all of the stuff on -fixes that got pulled in
are bug-fixes that would have been reasonable to pull in past -rc1. I'd
hope to merge them after Dave's -next merge, but that took longer than I
expected.

Let me know if this isn't what you want me to do and I'll build a
separate tree for fixes while -next is pending a merge.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOL9+2Qp8BWwlsTdMRAvY5AJ4iXLtApq4YXCxUevoMIBtEug8h9ACfXbUH
bTSMtnCQ6QAC7Qp2gprehCI=
=jYvn
-----END PGP SIGNATURE-----
--=-=-=--
