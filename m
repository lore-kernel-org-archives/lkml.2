Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab1KWDcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:32:05 -0500
Received: from home.keithp.com ([63.227.221.253]:53819 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab1KWDcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:32:03 -0500
From: Keith Packard <keithp@keithp.com>
To: Matthew Garrett <mjg@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: By default, enable RC6 on IVB and SNB when reasonable
In-Reply-To: <20111122201531.GD5547@srcf.ucam.org>
References: <1321684889-18691-1-git-send-email-keithp@keithp.com> <20111122201531.GD5547@srcf.ucam.org>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 22 Nov 2011 19:31:34 -0800
Message-ID: <861uszfrah.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Nov 2011 20:15:31 +0000, Matthew Garrett <mjg@redhat.com> wrote:

> So the user has to choose between 5W of power saving or having dmar? And=
=20
> we default to giving them dmar? I think that's going to come as a=20
> surprise to people.

You'd have to go into the BIOS to turn this on for most machines at
least?

But, yeah, it seems like we should be turning DMAR off unless explicitly
requested; I can't understand how you'd ever need this running native on
the hardware. Not exactly an area I care about deeply; I've always
worked hard to make sure all virtualization garbage is disabled on every
machine I use.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsxpFjYtFsjWk68qAQgLLQ/+P/SxISBo2Hfwd48c/RS4H3I39CxpZG9K
Q14ljTrfkrVxDAtm9gGkpvzTVHCLOpo8Y1pGtzlL+6x4J34a9fIgHXVCYzD2fJ+B
SaS2WiC4NB9eG1zPPyMHqkj3bubd/x6OK+m6j3z2FVdhImhiz3kk5F1BLzGsU3nn
g28ut5cgdj/JtbWrGFuAep5Tnx2DFaJgBENswbQwgkfUk74mAo5EKEteb8D2ofTI
8/loZMIxtBB5jY+EgrUth6oM8wKpQ/bEaIWu0D9dofEBdfuzD9drdeu4IxhqEEeB
23WXCmNgZzvYzxyFpGD3abLMQdoTjSWParZqSWfKfeUIzax3Wt9r1Gau70pqTA+n
OxkgHOCR+5i4kQFnNLbxI25IIa5XzTFrzZ4+eScpu0t8IzKyzPVF6w0C6stdYgKl
mYWu+yepmka81KoaqhA9aA7Zu3QM3iW2mn1A/jIbU3BB2HlRo7x/n5aXm4RTVxhN
j+j/5nkwHVkHFdQ/Z5/dCandmnsaEEx/TJyQvIUoKXE4laskvong1/dVJDwdIoTb
mYYGIMChb67k2eKhPUtQV9f5dNRhSuUJDQ6kiI/+uCnqZc9+S+cE0SxqYFfH2u8x
1ATanh156YU6llbUZkHY9Im0XVY52x3/Cjh/IX5oaWwu3oPs11HMW79hNxfB2z8R
okVuqsfrD54=
=bbxm
-----END PGP SIGNATURE-----
--=-=-=--
