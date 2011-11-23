Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab1KWHm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 02:42:56 -0500
Received: from home.keithp.com ([63.227.221.253]:49228 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab1KWHmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 02:42:55 -0500
From: Keith Packard <keithp@keithp.com>
To: Meelis Roos <mroos@linux.ee>
Cc: David Woodhouse <dwmw2@infradead.org>, dri-devel@lists.freedesktop.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: Bisected regression: hang on i915 between 3.1.0-rc9 and 3.1.0
In-Reply-To: <alpine.SOC.1.00.1111230911390.12655@math.ut.ee>
References: <alpine.SOC.1.00.1111221207090.6490@math.ut.ee> <alpine.SOC.1.00.1111221306410.8925@math.ut.ee> <86vcqcf3da.fsf@sumi.keithp.com> <alpine.SOC.1.00.1111230911390.12655@math.ut.ee>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 22 Nov 2011 23:42:56 -0800
Message-ID: <86obw3e133.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 09:28:52 +0200 (EET), Meelis Roos <mroos@linux.ee> wrot=
e:

> Yes, VT-x and VT-d are both enabled from BIOS setup.

Any reason for that? We've found all kinds of problems with DMAR enabled
on these machines that is only resolved by completely turning it
off. You might try with intel_iommu=3Doff and make sure that's stable.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsykADYtFsjWk68qAQjnnhAAsK0o+vB01L++73j0ub/hKMfQF76W0l46
I+EPKLq+CBRYnWgqGSYSEy+U8BXyIQLCXidce8ZvaWR1pJx50Ai5aCov/NIDemQ5
aVAA6b4nvjpFAqxSsl+5QQ+i3eaXmcOsx3zids5IgB4dorf+4To7mb3MGqORkUl8
+AmRnlXQZbDM5YTC8uEjF+SRIzpatq0GA7KYDPf4Q3/eOX5NTCqQ0K7o37BqWbUI
myqMV/+FKJ0JHu220BZf2Es4xEWR7D206sUY+GBZbOQEHtmHasr2WI/Zw+KrY4Sn
9HHHASrw5tTp6GkllZESV0cHeKVOPzfRjlXLMbwi4ZATldDl/n/08z1qqu30DTMU
DiVYVilB4uRqu0PkLFC6mAjQKHGpVUjHKMOtQc7ZVzXu4osd1ifWcZS+b5rU4bZ0
c+9YjvjcBuGJac11nGjqZ0lGZ9tTmjmkKo1dUgA8dXsQiC/I1P0lAeLEGTKVtlOt
pm1lL6eBSAPydcHdz31QBb9rDzu752V+EiFtYBFHR59DRNE4hlIQJi2fNKDxmWmx
mFPEAKpODmTaqcb0LcuHtnnnVHgjyKLJmY++4mLTeh1AKmH4o5akB3oFhe+z+Lpq
GV7e3YiSSMjzhgvpScjIWx5b64/c6m1yG+QZyhLbNkC7XtfPcuY/GBCm9IMyIV0u
YVaPKCgt94k=
=8kab
-----END PGP SIGNATURE-----
--=-=-=--
