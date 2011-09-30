Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab1I3I6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:58:39 -0400
Received: from home.keithp.com ([63.227.221.253]:44425 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab1I3I6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:58:37 -0400
From: Keith Packard <keithp@keithp.com>
To: Greg KH <greg@kroah.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 00/24] MacBook Air patch sequence (v2)
In-Reply-To: <20110930033356.GA11621@kroah.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <20110930033356.GA11621@kroah.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 01:58:29 -0700
Message-ID: <yunsjne8kzu.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Sep 2011 20:33:56 -0700, Greg KH <greg@kroah.com> wrote:

> Are these really all -stable material?

I think just the sequence that actually makes the machine work; the
scarier patches are those which reduce the mode setting time from 5-10s
down to .7s.

Is this stretching the bounds of what is acceptable for -stable? Would
it look better as a single patch, instead of 14 separate ones?

> I'm all for enabling new hardware like this, and overall, the patches
> aren't that bad, just want to verify this.

Let me know what you think; they'll be queued for 3.2 once they've
gotten review and (I hope) more testing. It's Jesse's fault there are
so many little patches; he asked me to split things up into separate
functional changes. It's either that, or I'm just looking to increase
the number of patches I have in the kernel.

> And, I do have to tell you, "curses, now I have no excuse to not buy
> that laptop!"

I'd rather have a 'regular' PC; getting Debian installed on this machine
was no picnic. But, I haven't seen anything else in this form factor
that includes a display port connector.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhYS1Qp8BWwlsTdMRAmLWAKDfCoN06BYafBtYfXpnapCNQ1eHxwCeMkUO
s6soLu55siOnIYPEQ3+ve+M=
=c6hp
-----END PGP SIGNATURE-----
--=-=-=--
