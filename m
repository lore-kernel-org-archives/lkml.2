Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1I1UCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 16:02:14 -0400
Received: from home.keithp.com ([63.227.221.253]:50685 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab1I1UCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 16:02:13 -0400
From: Keith Packard <keithp@keithp.com>
To: Paulo Zanoni <przanoni@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] PCH reference clock cleanups
In-Reply-To: <CA+gsUGTZfxt2L9mT-kYGGKiYhtRKn2xO5tXperwAWLVi2mKeOQ@mail.gmail.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <CA+gsUGTZfxt2L9mT-kYGGKiYhtRKn2xO5tXperwAWLVi2mKeOQ@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 28 Sep 2011 13:02:09 -0700
Message-ID: <yun62kcpha6.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Sep 2011 15:22:48 -0300, Paulo Zanoni <przanoni@gmail.com> wrote:

> I also tested the patch you sent today 1 hour ago (inline in one of
> the emails) and things still work with it. I'll keep using these
> patches since they fix my laptop. Any problem will be reported.

Thanks. I think we're failing to reset the register on resume, leading
to a black screen for me. I may just break down and fix this the 'right'
way, enabling and disabling the clock sources during mode setting,
depending on which outputs are in use.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOg31BQp8BWwlsTdMRAiniAJ9st3zqBACMVPNWcaaOtcLf2RZkyQCeIm/K
YuNmCCoGoU0WBt/0ssQBDLE=
=rcjx
-----END PGP SIGNATURE-----
--=-=-=--
