Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab2JSDRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:17:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:54283 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757734Ab2JSDRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/37] 3.0.47-stable review
Date: Thu, 18 Oct 2012 20:16:23 -0700
Message-Id: <20121019031302.789593147@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.47 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct 21 03:12:48 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.47-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Maxim Kachur <mcdebugger@duganet.ru>
    ALSA: emu10k1: add chip details for E-mu 1010 PCIe card

Takashi Iwai <tiwai@suse.de>
    ALSA: ac97 - Fix missing NULL check in snd_ac97_cvol_new()

Nikola Pajkovsky <npajkovs@redhat.com>
    udf: fix retun value on error path in udf_load_logicalvol

Peter Huewe <peter.huewe@infineon.com>
    tpm: Propagate error from tpm_transmit to fix a timeout hang

H. Peter Anvin <hpa@zytor.com>
    x86, random: Verify RDRAND functionality and allow it to be disabled

H. Peter Anvin <hpa@zytor.com>
    x86, random: Architectural inlines to get random integers with RDRAND

Jan Kara <jack@suse.cz>
    jbd: Fix assertion failure in commit code due to lacking transaction credits

Egbert Eich <eich@suse.de>
    drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy().

Jean-Christian de Rivaz <jc@eclis.ch>
    Add CDC-ACM support for the CX93010-2x UCMxx USB Modem

Jan Engelhardt <jengelh@inai.de>
    netfilter: xt_limit: have r->cost != 0 case work

Florian Westphal <fw@strlen.de>
    netfilter: limit, hashlimit: avoid duplicated inline

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_ct_expect: fix possible access to uninitialized timer

Patrick McHardy <kaber@trash.net>
    netfilter: nf_nat_sip: fix via header translation with multiple parameters

Lin Ming <mlin@ss.pku.edu.cn>
    ipvs: fix oops on NAT reply in br_nf context

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expectation

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
    netfilter: nf_ct_ipv4: packets with wrong ihl are invalid

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack: fix racy timer handling with reliable events

Julian Anastasov <ja@ssi.bg>
    ipvs: fix oops in ip_vs_dst_event on rmmod

Matt Carlson <mcarlson@broadcom.com>
    tg3: Apply short DMA frag workaround to 5906

Amerigo Wang <amwang@redhat.com>
    pktgen: fix crash when generating IPv6 packets

Hildner, Christian <christian.hildner@siemens.com>
    timers: Fix endless looping between cascade() and internal_add_timer()

Daniel Drake <dsd@laptop.org>
    viafb: don't touch clock state on OLPC XO-1.5

Alexander Holler <holler@ahsoftware.de>
    video/udlfb: fix line counting in fb_write

Matthew Garrett <mjg59@srcf.ucam.org>
    module: taint kernel when lve module is loaded

Ian Kent <raven@themaw.net>
    autofs4 - fix reset pending flag on mount fail

Tejun Heo <tj@kernel.org>
    block: fix request_queue->flags initialization

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/bootup: allow read_tscp call for Xen PV guests.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/bootup: allow {read|write}_cr8 pvops call.

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Ensure that the TCP socket is closed when in CLOSE_WAIT

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: cdev: fix user memory corruption (i386 userland on amd64 kernel)

Simon Horman <horms@verge.net.au>
    ARM: 7541/1: Add ARM ERRATA 775420 workaround

Hugh Dickins <hughd@google.com>
    tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking

Jason Wessel <jason.wessel@windriver.com>
    mips,kgdb: fix recursive page fault with CONFIG_KPROBES

Feng Tang <feng.tang@intel.com>
    ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop

Feng Tang <feng.tang@intel.com>
    ACPI: EC: Make the GPE storm threshold a module parameter

Stanislav Kinsbursky <skinsbursky@parallels.com>
    lockd: use rpc client's cl_nodename for id encoding

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels


-------------

Diffstat:

 Documentation/kernel-parameters.txt             |  5 +++++
 Makefile                                        |  4 ++--
 arch/arm/Kconfig                                | 10 ++++++++++
 arch/arm/include/asm/vfpmacros.h                |  4 ++--
 arch/arm/mm/cache-v7.S                          |  3 +++
 arch/mips/kernel/kgdb.c                         |  9 +++++++++
 arch/x86/Kconfig                                |  9 +++++++++
 arch/x86/include/asm/archrandom.h               | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/Makefile                    |  1 +
 arch/x86/kernel/cpu/common.c                    |  2 ++
 arch/x86/kernel/cpu/rdrand.c                    | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c                        | 18 +++++++++++++++++-
 block/blk-core.c                                |  2 +-
 drivers/acpi/ec.c                               | 30 +++++++++++++++++++++++++-----
 drivers/char/tpm/tpm.c                          | 21 ++++++++++++++-------
 drivers/firewire/core-cdev.c                    |  4 ++--
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |  6 +-----
 drivers/net/tg3.c                               |  5 +++--
 drivers/usb/class/cdc-acm.c                     |  3 +++
 drivers/video/udlfb.c                           |  2 +-
 drivers/video/via/via_clock.c                   | 19 +++++++++++++++++++
 fs/autofs4/root.c                               |  6 ++++--
 fs/ceph/export.c                                | 18 ++++++++++++++----
 fs/gfs2/export.c                                |  4 ++++
 fs/isofs/export.c                               |  2 +-
 fs/jbd/commit.c                                 | 45 ++++++++++++++++++++++++++++++++++-----------
 fs/jbd/transaction.c                            | 64 ++++++++++++++++++++++++++++++++++++++++++++--------------------
 fs/lockd/mon.c                                  |  4 +++-
 fs/reiserfs/inode.c                             |  6 +++++-
 fs/udf/super.c                                  |  5 ++++-
 fs/xfs/linux-2.6/xfs_export.c                   |  3 +++
 include/net/ip_vs.h                             |  2 +-
 include/net/netfilter/nf_conntrack_ecache.h     |  1 +
 kernel/module.c                                 |  4 ++++
 kernel/timer.c                                  | 10 ++++++----
 mm/shmem.c                                      |  6 ++++--
 net/core/pktgen.c                               |  2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c  |  8 ++++++++
 net/ipv4/netfilter/nf_nat_sip.c                 | 10 +++++++---
 net/netfilter/ipvs/ip_vs_ctl.c                  |  5 +++--
 net/netfilter/nf_conntrack_core.c               | 16 +++++++++++-----
 net/netfilter/nf_conntrack_expect.c             | 29 ++++++-----------------------
 net/netfilter/xt_hashlimit.c                    |  8 +++-----
 net/netfilter/xt_limit.c                        | 13 ++++++-------
 net/sunrpc/xprtsock.c                           | 21 ++++++++++++++++-----
 sound/pci/ac97/ac97_codec.c                     |  2 ++
 sound/pci/emu10k1/emu10k1_main.c                |  9 +++++++++
 47 files changed, 481 insertions(+), 127 deletions(-)


