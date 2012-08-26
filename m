Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab2HZXtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 19:49:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34856 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab2HZXsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 19:48:51 -0400
Date: Sun, 26 Aug 2012 16:48:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.10
Message-ID: <20120826234846.GA11600@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.10 kernel.

All users of the 3.4 kernel series must upgrade.

Note, there is a reported problem with the Intel graphics driver in this
release that might affect you, or not, please test.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                    |    2=20
 arch/s390/kernel/compat_linux.c             |    2=20
 arch/s390/kernel/compat_wrapper.S           |    4=20
 arch/x86/xen/p2m.c                          |   36 +++
 drivers/dma/imx-dma.c                       |   36 ++-
 drivers/gpu/drm/i915/intel_display.c        |   11 -
 drivers/gpu/drm/i915/intel_dp.c             |   18 -
 drivers/gpu/drm/i915/intel_ringbuffer.c     |    7=20
 drivers/gpu/drm/nouveau/nvd0_display.c      |    2=20
 drivers/gpu/drm/radeon/atombios_crtc.c      |   14 +
 drivers/gpu/drm/radeon/evergreen.c          |   71 +------
 drivers/gpu/drm/radeon/ni.c                 |   14 +
 drivers/gpu/drm/radeon/radeon_asic.h        |    8=20
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    4=20
 drivers/gpu/drm/radeon/radeon_mode.h        |    1=20
 drivers/gpu/drm/radeon/rv515.c              |   13 -
 drivers/infiniband/ulp/srp/ib_srp.c         |   87 ++++++--
 drivers/net/wireless/rt2x00/rt2800usb.c     |    1=20
 drivers/tty/serial/pmac_zilog.c             |   12 -
 drivers/usb/gadget/u_ether.c                |    6=20
 drivers/usb/host/pci-quirks.c               |    7=20
 drivers/usb/host/pci-quirks.h               |    1=20
 drivers/usb/host/xhci-pci.c                 |   10=20
 drivers/usb/host/xhci-ring.c                |   36 ++-
 drivers/usb/host/xhci.c                     |    8=20
 drivers/usb/host/xhci.h                     |    1=20
 drivers/usb/serial/ftdi_sio.c               |    1=20
 drivers/usb/serial/ftdi_sio_ids.h           |    7=20
 drivers/usb/serial/mos7840.c                |    9=20
 drivers/usb/serial/option.c                 |  281 +++++++++++------------=
-----
 fs/ext4/extents.c                           |    1=20
 fs/ext4/super.c                             |    6=20
 fs/fuse/file.c                              |    2=20
 fs/jbd2/journal.c                           |    3=20
 include/drm/drm_pciids.h                    |    3=20
 include/linux/jbd2.h                        |    1=20
 include/linux/usb.h                         |   21 ++
 37 files changed, 408 insertions(+), 339 deletions(-)

Alex Deucher (4):
      drm/radeon: properly handle crtc powergating
      drm/radeon: add some new SI pci ids
      drm/radeon: fix bank tiling parameters on cayman
      drm/radeon: fix bank tiling parameters on evergreen

Bart Van Assche (1):
      IB/srp: Fix a race condition

Bj=C3=B8rn Mork (1):
      USB: option: add ZTE K5006-Z

Christoph Bumiller (1):
      drm/nvd0/disp: mask off high 16 bit of negative cursor x-coordinate

Daniel Vetter (3):
      drm/i915: correctly order the ring init sequence
      drm/i915: ignore eDP bpc settings from vbt
      drm/i915: reorder edp disabling to fix ivb MacBook Air

Fabio Estevam (1):
      dma: imx-dma: Fix kernel crash due to missing clock conversion

Greg Kroah-Hartman (1):
      Linux 3.4.10

Gustavo Padovan (1):
      USB: add USB_VENDOR_AND_INTERFACE_INFO() macro

Heiko Carstens (2):
      s390/compat: fix compat wrappers for process_vm system calls
      s390/compat: fix mmap compat system calls

Jason Wessel (1):
      pmac_zilog,kdb: Fix console poll hook to return instead of loop

Jeongdo Son (1):
      rt2x00: Add support for BUFFALO WLI-UC-GNM2 to rt2800usb.

Jerome Glisse (1):
      drm/radeon: do not reenable crtc after moving vram start address

Jesse Barnes (1):
      drm/i915: prefer wide & slow to fast & narrow in DP configs

Mark Ferrell (1):
      usb: serial: mos7840: Fixup mos7840_chars_in_buffer()

Michael Grzeschik (1):
      usb: gadget: u_ether: fix kworker 100% CPU issue with still used inte=
rfaces in eth_stop

Ozan =C3=87a=C4=9Flayan (1):
      USB: ftdi_sio: Add VID/PID for Kondo Serial USB

Sarah Sharp (4):
      xhci: Add Etron XHCI_TRUST_TX_LENGTH quirk.
      xhci: Increase reset timeout for Renesas 720201 host.
      xhci: Switch PPT ports to EHCI on shutdown.
      xhci: Fix bug after deq ptr set to link TRB.

Stefano Stabellini (1):
      xen: mark local pages as FOREIGN in the m2p_override

Theodore Ts'o (4):
      ext4: make sure the journal sb is written in ext4_clear_journal_err()
      ext4: avoid kmemcheck complaint from reading uninitialized memory
      ext4: fix long mount times on very big file systems
      ext4: fix kernel BUG on large-scale rm -rf commands

Zach Brown (1):
      fuse: verify all ioctl retry iov elements

fangxiaozhi (1):
      USB: support the new interfaces of Huawei Data Card devices in option=
 driver


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJQOrXeAAoJEDjbvchgkmk+2BUQAL7EBCV+FTJHjRRkFcqehKj8
Q1ZMvCrobB63gpG2FI1p867m6AMUP4XVJldGIhUIfcxUhlTpnx7mGp6HMjv9Py87
RoDTP7MPOQUu+Uh5Lom9LZ1C1ysVBY6QYa9ACYewc9eqnVb0Cjfg7Q71EtcVTFWB
ST6v+Sl352IxFp1tWFN51/0m6GuW7HDr/7IO338pfAWwsLnSHNT1tdLY+/+F87bG
BqraEFQPBpf1Sg8EWc/Oh8ySO4GoyYbjepcVbteEM/te0UogpL82kGSB+9Gv3H1J
325bVQxDlalyKTRFFueA/YpsNpibHQ9X96Wt9GlCRe57Sv63Q+W7fvbfWpO1fFB7
E5Dk1xXGsMT7kT+7g8KzgZWsWzCM+NH2RygS6bXhmJqua7eeXA+hE2V7XgoOMs8o
vLU1lFDuS/5xhxhuU7LiuTtrQBDtGzA5tZleZQO9G3ZDUG6wk8ux9Q+kO0SP3isU
oWHv4PD8UKlKzQy3Xr5bU4Ak7jG6pxslccjhnh3yejjXb0IGGcXDuWKghXEJUrWq
/Byb59xHERkEg7xdNG05nsbdnwbIVjpYViOMkWRgWjTva8n2r4daHhihiyhbKHAc
z4yX8FEVwWSqjopG7Fw1zvrLD85f+oV20nmSXUbPRaXTEMJMTosFB/dJaBop0zBw
k2mlUsg9YXV/eEk5LHNS
=uYUr
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
