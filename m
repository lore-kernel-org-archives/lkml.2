Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2J1SAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 14:00:54 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54388 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab2J1SAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 14:00:52 -0400
Date: Sun, 28 Oct 2012 11:01:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.49
Message-ID: <20121028180141.GA10972@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.49 kernel.

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

 Makefile                                  |    2=20
 arch/sparc/kernel/perf_event.c            |   15 -
 arch/sparc/kernel/sys_sparc_64.c          |   10 -
 arch/sparc/kernel/syscalls.S              |   32 +--
 arch/sparc/mm/init_64.c                   |   28 ++
 arch/tile/Makefile                        |    4=20
 arch/x86/kernel/entry_32.S                |    8=20
 arch/x86/kernel/entry_64.S                |    2=20
 arch/x86/kernel/setup.c                   |   17 +
 arch/x86/oprofile/nmi_int.c               |    2=20
 drivers/edac/amd64_edac.c                 |   11 -
 drivers/gpu/drm/i915/i915_reg.h           |    5=20
 drivers/gpu/drm/i915/intel_display.c      |    4=20
 drivers/media/video/au0828/au0828-video.c |   12 -
 drivers/net/skge.c                        |    7=20
 drivers/pcmcia/pxa2xx_sharpsl.c           |    2=20
 drivers/usb/class/cdc-acm.c               |   22 +-
 drivers/usb/host/xhci-mem.c               |    7=20
 drivers/usb/host/xhci-ring.c              |  282 +++++++++++++++++++++++++=
++++-
 drivers/usb/host/xhci.c                   |   33 ++-
 drivers/usb/host/xhci.h                   |   22 ++
 drivers/usb/serial/option.c               |   92 +++++++--
 fs/lockd/clntxdr.c                        |    2=20
 fs/lockd/mon.c                            |    4=20
 fs/lockd/svcproc.c                        |    3=20
 kernel/cgroup.c                           |    3=20
 kernel/sys.c                              |   12 -
 net/core/neighbour.c                      |    6=20
 net/ipv4/tcp_ipv4.c                       |    7=20
 net/ipv6/tcp_ipv6.c                       |    3=20
 net/rds/send.c                            |    2=20
 net/sunrpc/cache.c                        |    4=20
 32 files changed, 545 insertions(+), 120 deletions(-)

Al Viro (1):
      sparc64: fix ptrace interaction with force_successful_syscall_return()

Alexey Kuznetsov (1):
      tcp: resets are misrouted

Andrew Morton (1):
      amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]

Arnd Bergmann (1):
      pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops

Bj=F8rn Mork (2):
      USB: option: blacklist net interface on ZTE devices
      USB: option: add more ZTE devices

Chris Metcalf (1):
      arch/tile: avoid generating .eh_frame information in modules

Daisuke Nishimura (1):
      cgroup: notify_on_release may not be triggered in some cases

Dan Carpenter (1):
      oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()

David S. Miller (3):
      sparc64: Like x86 we should check current->mm during perf backtrace g=
eneration.
      sparc64: Fix bit twiddling in sparc_pmu_enable_event().
      sparc64: Be less verbose during vmemmap population.

David Vrabel (1):
      xen/x86: don't corrupt %eip when returning from a signal handler

Devin Heitmueller (1):
      media: au0828: fix case where STREAMOFF being called on stopped strea=
m causes BUG()

Elric Fu (4):
      xHCI: add cmd_ring_state
      xHCI: add aborting command ring function
      xHCI: cancel command after command timeout
      xHCI: handle command after aborting the command ring

Graham Gower (1):
      skge: Add DMA mask quirk for Marvell 88E8001 on ASUS P5NSLI motherboa=
rd

Greg Kroah-Hartman (2):
      Revert: lockd: use rpc client's cl_nodename for id encoding
      Linux 3.0.49

Jacob Shin (1):
      x86: Exclude E820_RESERVED regions and memory holes above 4 GB from d=
irect mapping.

Jesse Barnes (1):
      drm/i915: apply timing generator bug workaround on CPT and PPT

Jiri Kosina (1):
      sparc64: do not clobber personality flags in sys_sparc64_personality()

Kees Cook (2):
      kernel/sys.c: fix stack memory content leak via UNAME26
      use clamp_t in UNAME26 fix

Ming Lei (1):
      USB: cdc-acm: fix pipe type of write endpoint

Nicolas Boullis (1):
      usb: acm: fix the computation of the number of data bits

Sasha Levin (1):
      SUNRPC: Prevent kernel stack corruption on long values of flush

Trond Myklebust (1):
      NLM: nlm_lookup_file() may return NLMv4-specific error codes

jeff.liu (1):
      RDS: fix rds-ping spinlock recursion

ramesh.nagappa@gmail.com (1):
      net: Fix skb_under_panic oops in neigh_resolve_output


--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQjXMFAAoJEDjbvchgkmk+LQMP/j8nG1n3fK2C4G5d8JN2+8M7
Gh6Mc952Lyay/6aCFkJ4WJ3s7BzryhCQ3MOzU8NSBwyXfrO9xmRBCbRnijsDTSxt
j7sjL+JAn/ahUvDPu6cO+uhJpyTyG7deYl1GwF7so+hs9p8bbWCw717Xpxze9tBz
IqRB/YpcZ16hrxxGJRm4VkqwJnzwIklTxQw33DBSLQkLSzqOCOUUPHPLCxUccA1d
2bbJiu2pWIrmwZ4SyjYbcIt8N/bNe6zOOaJZtxiWTodwClSIvTW3HWTvkXjwxDCo
BsIKZ7G9ho/t8ZXaBLaIMwSv3Jg5iqLCLkvjAucd0pE60Jhd0c0NMI/fbjvdGn59
HQZH+N3YEuorwC0JSg0o83/W16FEfzf67/pRntaZaHSD9yxdtcSCX1oZUVnEuZC+
Dy5NsL7WsXxZXSbwkTwYrs5sz6zb2IhuvI/LA3BSG9/8Ov76u+xgfdGv2n7TEIqH
L/eue6KSLUVgrk/IDNGGmX/g9p1Oz2hMS9jXQi5QaYw+WhbVQu8RP2HHn41P441I
hSibKFfCdPFyt7l1h2JlA5bxxKjNLDib8P2igfi16vFEtDjO6ElEMFeFwzBrGi7D
Vl+31r5NDIEs9z8nXgWwO6UDDoGgLjBi1XcCctjI29f7u+WhqSV4/fDtLeK2B4eM
nnJv330mbUWDKp1KkhnU
=INDr
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
