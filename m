Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1JYFUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 01:20:47 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:36447 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624Ab1JYFUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 01:20:46 -0400
X-Sasl-enc: Up5IrRTr6aoKx75HMIPbUTTYR3YldA9k6ZddtGfCTfvc 1319520045
Date: Tue, 25 Oct 2011 07:19:28 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.8
Message-ID: <20111025051928.GA7997@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.8 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                              |    2=20
 arch/arm/kernel/perf_event_v7.c       |    4=20
 arch/arm/mm/init.c                    |    7 +
 arch/x86/mm/init.c                    |    3=20
 crypto/ghash-generic.c                |    6 +
 drivers/firewire/sbp2.c               |    4=20
 drivers/gpu/drm/radeon/atom.c         |   15 ++
 drivers/gpu/drm/radeon/atom.h         |    1=20
 drivers/gpu/drm/ttm/ttm_bo.c          |   10 +
 drivers/gpu/drm/ttm/ttm_bo_util.c     |    2=20
 drivers/hid/hid-ids.h                 |    3=20
 drivers/hid/hid-magicmouse.c          |   10 +
 drivers/hid/usbhid/hid-quirks.c       |    1=20
 drivers/hwmon/w83627ehf.c             |   20 ++-
 drivers/media/video/uvc/uvc_entity.c  |    2=20
 drivers/platform/x86/samsung-laptop.c |   10 +
 fs/cifs/cifsfs.c                      |   10 +
 fs/fuse/dev.c                         |   12 +-
 fs/hfsplus/hfsplus_fs.h               |   16 ++
 fs/hfsplus/part_tbl.c                 |   32 +++--
 fs/hfsplus/super.c                    |   16 +-
 fs/hfsplus/wrapper.c                  |   87 +++++++++++----
 fs/xfs/linux-2.6/xfs_linux.h          |    2=20
 fs/xfs/linux-2.6/xfs_super.c          |   48 ++------
 fs/xfs/quota/xfs_dquot_item.c         |   10 +
 fs/xfs/xfs_buf_item.c                 |    3=20
 fs/xfs/xfs_inode_item.c               |   10 +
 fs/xfs/xfs_trans.c                    |   27 ++++
 fs/xfs/xfs_trans.h                    |    2=20
 fs/xfs/xfs_trans_ail.c                |  192 ++++++++++++++++++++++++-----=
-----
 fs/xfs/xfs_trans_priv.h               |   18 +--
 kernel/posix-cpu-timers.c             |    7 -
 kernel/sys.c                          |    2=20
 mm/migrate.c                          |    8 -
 net/x25/af_x25.c                      |    3=20
 sound/pci/hda/hda_intel.c             |    1=20
 sound/pci/hda/patch_conexant.c        |    1=20
 37 files changed, 413 insertions(+), 194 deletions(-)

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOpkbKAAoJEDjbvchgkmk+taAP/R4ldm5KgnUSMsNbigY9M6Ft
3PJKaNFPyf+n2Qp1kU2DsE5DUM2t/NZjHDHBq74EK8En2AWxb50kl2jbZXysxhji
RHzRH/Y2XDxvHeHCSetZy6HIS5kqt29EpTTa6foNn8OUAsYWh1xk1CNgG52dIT7r
7dokpEzpLKeHKN/VfW+JR4rsYFCpuPaoM/38kPZIuDKDgNVLdcUP+nHZcULeqeun
IrK5lN3yhLXvz9v+jMBRP4kBMnDh0Mn7xz2Pby9ze1H6KiK3WbJzJ2l5hAKWnLhm
omPa8qPxOgAKDkF0WXzIw4YMIjaPky2JkW/91gOl7Hk1ssecZdaiHlOokwrhiMGZ
GRqfQt2aiLi3+95oCIv7cpbYe5YezDO/l1Zd7jkMt9G6oAo/vIY4ia4MmlVTfbW/
JKwtwHNvwP+VelPREmE1lxAMIsvvvAvWAAtQmhNnv0xzibLf1ANMtnzM8T7VjKh1
J8XpDB397LfyT61VJIHtQTohDZTp2csV/xe0g/q3LGO3aXeJnXVadkdTSKaJkRGj
ULfIKKfWi3hk1vaFWG8WSj3azFOs2vW+7vSUirh6WXlsly8KqJ6pgNUK5JE9yXo7
LJf06PrI+mycTKOUBO2W4eMeBh6IhpNvZFx95sNm+hl/2PvWPwCu+qHv2vhPwG1M
MacjhzXHStFnrYcDoQfa
=PCTb
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
