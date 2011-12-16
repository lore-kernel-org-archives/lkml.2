Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196Ab1LPRFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 12:05:44 -0500
Received: from home.keithp.com ([63.227.221.253]:34647 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab1LPRFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:05:38 -0500
From: Keith Packard <keithp@keithp.com>
To: tino.keitel+xorg@tikei.de, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rocko Requin <rockorequin@hotmail.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] kernel BUG at drivers/gpu/drm/i915/i915_gem
In-Reply-To: <20111216163839.GA7884@x61.home>
References: <BAY151-W65C39B54A590BCA4E3AEBDA1B80@phx.gbl> <CAKMK7uEm8=bGWxDSbLtOEM3CBmbMSH+gWrUy0Od327ozvjOd5g@mail.gmail.com> <BAY151-W537E90462ED274C21FDA4CA1BE0@phx.gbl> <CAKMK7uH-_VzaeTsNJYL_wMfUHqMkvG-BSCxicfQ--RQ-_O5jsg@mail.gmail.com> <BAY151-W53C3AD24F2938042D0F733A1BC0@phx.gbl> <CAKMK7uGpn6AJGtbMCYWW1ziR=Zs+E9LB=aiB5aUu0unfVW=2oA@mail.gmail.com> <20111214195751.GA31690@mac.home> <20111215185415.GA3445@mac.home> <20111216163839.GA7884@x61.home>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 16 Dec 2011 09:06:33 -0800
Message-ID: <864nx08mzq.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Dec 2011 17:38:39 +0100, tino.keitel+xorg@tikei.de wrote:

> Hum, could this be related to the RC6 vs. IOMMU issue? I have
> CONFIG_INTEL_IOMMU enabled in 3.2, and disabled in 3.1, and boot with
> i915.i915_enable_rc6=3D1.

Very likely -- RC6 and semaphores are not compatible with IOMMU. You
should be able to just disable VTd in your BIOS and use the kernel with
IOMMU enabled.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTut6mTYtFsjWk68qAQjt6hAAtvF6peXrhxwnowVSZO5OS016zfX3ciqf
8rf3Sw/1J/+PMxf7Cxw3AY+CuBybQg7HDmZnWvrvfdhHdJ9HEvjALxUBYXD6bh3L
RA6ZrIK1AHLHQa1utG5XYym26Ayy6bAfJC0ExU0EhElbpZiveaZolRbsUQRWKRCv
fAmDWjiSXRaxXWWakqTNUrJtlON/+b/xnAs/wC3hMK7qp6XzAvFWXqzOg1Q4K6gI
lE5KynAHjTtfwbh+6x6h0/Ps71rPF+ODdUjo/Hp51jWlUguqVeJIFDvpphZOyYbM
v0eBEYNRcSjYTHXou32PEbTYY2G1M82Y1k29AmXQKrkrA/9fWBAuInlaLu4px8Nn
GZqZS8nIUmPseLObWfVMBkw0ja9tszatnh4GkunwFIiRCp3CUscIZiD6NPK2aOji
m2xdVRXGovck6iUWqU9w+gxqkjSu0WSWCKooyy9ejKbHS2dGsTOIms0z8ig+LAD8
NUkKKqr5cxg9um81GnVrwg/ld3Bfil8QijINDqiIr1TctbvsHCAMca49TuzwNNa9
yCCkoIU0GWCofxgBGig5qTNMEz5MgJoZSNorDdLQnsgAwG2dj+jGIfxsHOWL+apG
FPpqFACQGEtXj5Vd1ZHh36krHBwPsqG6BPxFd0pK9mn1EwvZN3NGQZiKMreWK60/
nDeW1syVWmM=
=RRHE
-----END PGP SIGNATURE-----
--=-=-=--
