Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2BTWOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 17:14:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34115 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2BTWO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 17:14:29 -0500
Date: Mon, 20 Feb 2012 14:13:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.22
Message-ID: <20120220221351.GA21224@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.22 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                 |    2=20
 arch/x86/pci/xen.c                       |    2=20
 crypto/sha512_generic.c                  |   83 +++++++++++++-------------=
-----
 drivers/gpio/pca953x.c                   |    6 +-
 drivers/gpu/drm/i915/intel_lvds.c        |    8 ++
 drivers/hwmon/f75375s.c                  |    4 -
 include/linux/bitops.h                   |   20 +++++++
 include/linux/proportions.h              |    4 +
 include/trace/events/writeback.h         |    5 +
 kernel/relay.c                           |   10 ++-
 mm/slub.c                                |    6 ++
 net/mac80211/rx.c                        |    2=20
 sound/pci/intel8x0.c                     |    6 ++
 tools/perf/bench/mem-memcpy-x86-64-asm.S |    6 ++
 tools/perf/util/evsel.c                  |    1=20
 15 files changed, 108 insertions(+), 57 deletions(-)

Alexey Dobriyan (1):
      crypto: sha512 - use standard ror64()

Dan Carpenter (1):
      relay: prevent integer overflow in relay_open()

Daniel T Chen (1):
      ALSA: intel8x0: Fix default inaudible sound on Gateway M520

Daniel Vetter (1):
      drm/i915: no lvds quirk for AOpen MP45

David Jander (1):
      gpio/pca953x: Fix warning of enabled interrupts in handler

Eliad Peller (1):
      mac80211: timeout a single frame in the rx reorder buffer

Eric Dumazet (1):
      slub: fix a possible memleak in __slab_alloc()

Greg Kroah-Hartman (1):
      Linux 3.0.22

Herbert Xu (2):
      crypto: sha512 - Use binary and instead of modulus
      crypto: sha512 - Avoid stack bloat on i386

Jiri Olsa (1):
      perf tools: Fix perf stack to non executable on x86_64

Naveen N. Rao (1):
      perf evsel: Fix an issue where perf report fails to show the proper p=
ercentage

Nikolaus Schulz (2):
      hwmon: (f75375s) Fix bit shifting in f75375_write16
      hwmon: (f75375s) Fix automatic pwm mode setting for F75373 & F75375

Stefano Stabellini (1):
      xen pvhvm: do not remap pirqs onto evtchns if !xen_have_vector_callba=
ck

Wu Fengguang (2):
      lib: proportion: lower PROP_MAX_SHIFT to 32 on 64-bit kernel
      writeback: fix dereferencing NULL bdi->dev on trace_writeback_queue


--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPQsWfAAoJEDjbvchgkmk+5xAP/RXfs0UhcwJgLwov/6rUHXAW
Gp7Fpc6v+xUtwwD4A/00q0MBzRbglJbrPPdnX28Fc8K9wkguJQy/FU8wV8t5Ydph
rnIoQ34h4sSp7Y02KwK8GiBg56ymflp1j+d1TcKUZ8ZnARG4JrozgFNBoFtQnFqG
1C2DEAFzuQDrVztpslCUcuflSW8tOJQLuHsKoPto9hzipJ80Xf3UMN82eLJyW4/y
kdbnWCt+4hGiVto3hyn0erVgQJNNvmo/Yd3im2sn4SiW6V/jh4pXJBXMByNPeI5T
yf1k69j+Te8WDOafuOOrvKKMbUWLyYowazX89r8cevAD8H5YvvxFMD7pc825dimd
0Huhh2VamFLiiYDA6aoBLUj0YMpFlcvUzIvOKz/i5hPYUR4kczd4/I4AVQ5xz36l
r1DWlAIjdbFPYMnOY/TiDwvLMNY8JhRqKnMW9KC29njyxxxhYiqaWOnXHs23EUCb
ndhSxfGXhuwb96+UG74ldaiKTGY6lYTRioBd3QjSG9L68PUu6LPGuxEDD6PYXX3d
yrBQX5B4VwLArFpDVdCfYOTTnxzcpfHEKWziBwTkirJr2QDFgqRPObhWnGLsaOk/
tP4bMKyzAn3xbLdAK3Jq7l2Tft74mvybgOS6KrOdz53sohwI/5tdr1qx3+cIeqAp
5tHsSMZcyusuIf8SECnS
=J3Ae
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
