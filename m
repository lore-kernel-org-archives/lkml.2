Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab1FEUQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 16:16:45 -0400
Received: from home.keithp.com ([63.227.221.253]:40670 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab1FEUQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 16:16:44 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org,
        "drivers\, Intel" <Intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: drivers/drm/i915 maintenance process
In-Reply-To: <1307255026.17387.8.camel@t60prh>
References: <yunipskolss.fsf@aiko.keithp.com> <1307255026.17387.8.camel@t60prh>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 05 Jun 2011 13:16:38 -0700
Message-ID: <yunlixg2fvd.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 05 Jun 2011 16:23:43 +1000, Dave Airlie <airlied@redhat.com> wrote:

> So when Linus is releasing rc4/5 you should really be cutting down stuff
> going into your -next, and getting the tree ready for me to take. We can
> probably add your tree direct to the -next git list as well so that we
> can get the benefits of -next testing earlier.

Right, even earlier than I had thought. That should be pretty easy to follo=
w.

> Just make sure any merge commits are documented in the commit, this
> generally means having to git commit --amend the merge commit since most
> of the time it doesn't allow you to write anything unless you get a
> conflict, esp if its a strange non i915 commit (like say some ACPI or
> bluetooth commit that fixes a test laptop).

Thanks for your comments; I'll try to have -next ready by rc4/rc5 time
this release.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN6+QmQp8BWwlsTdMRAgWJAJ49w56z5GsMbI+Zah51igvsVPpdgQCcCwDu
zAErxwwlrXX7Q+WpS0VvQmU=
=aYqV
-----END PGP SIGNATURE-----
--=-=-=--
