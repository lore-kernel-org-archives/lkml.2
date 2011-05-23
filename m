Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab1EWSlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:41:22 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53799 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756328Ab1EWSlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:41:21 -0400
X-Sasl-enc: gNFTBHjXSIgLkRyUPah4mT5PcckpG9BdXkNWeU44/b0m 1306176079
Date: Mon, 23 May 2011 11:40:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.41
Message-ID: <20110523184054.GA12920@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.41 kernel.

All users of the 2.6.32 series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 +-
 arch/x86/include/asm/apicdef.h           |    1 +
 arch/x86/kernel/cpu/amd.c                |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_amd.c     |    1 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   12 +++++++-----
 drivers/net/Makefile                     |    6 +++---
 drivers/net/ehea/ehea_ethtool.c          |   21 +++++++++++++--------
 drivers/net/hydra.c                      |   14 +++++++-------
 drivers/net/ne-h8300.c                   |   16 ++++++++--------
 drivers/net/netxen/netxen_nic.h          |    1 -
 drivers/net/netxen/netxen_nic_init.c     |    1 -
 drivers/net/netxen/netxen_nic_main.c     |    1 -
 drivers/net/slip.c                       |    4 +++-
 drivers/net/vmxnet3/vmxnet3_ethtool.c    |    3 +++
 drivers/net/wireless/libertas/cmd.c      |    6 ++++--
 drivers/net/zorro8390.c                  |   12 ++++++------
 drivers/scsi/megaraid/megaraid_sas.c     |    3 +++
 fs/cifs/connect.c                        |   10 ++++++++--
 fs/cifs/sess.c                           |    4 +++-
 fs/partitions/efi.c                      |    6 ++++++
 kernel/time/clocksource.c                |    2 +-
 kernel/time/tick-broadcast.c             |   12 +++++++++++-
 kernel/time/timekeeping.c                |   11 +++++++++--
 net/dccp/options.c                       |    2 ++
 24 files changed, 102 insertions(+), 53 deletions(-)

Ben Hutchings (1):
      netxen: Remove references to unified firmware file

Bjørn Mork (1):
      megaraid_sas: Sanity check user supplied length before passing it to dma_alloc_coherent()

Borislav Petkov (2):
      Revert "x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors"
      x86, AMD: Fix ARAT feature setting again

Dan Rosenberg (1):
      dccp: handle invalid feature options length

Geert Uytterhoeven (3):
      ne-h8300: Fix regression caused during net_device_ops conversion
      hydra: Fix regression caused during net_device_ops conversion
      zorro8390: Fix regression caused during net_device_ops conversion

Greg Kroah-Hartman (1):
      Linux 2.6.32.41

Jeff Layton (2):
      cifs: check for bytes_remaining going to zero in CIFS_SessSetup
      cifs: add fallback in is_path_accessible for old servers

John Stultz (2):
      Fix time() inconsistencies caused by intermediate xtime_cache values being read
      clocksource: Install completely before selecting

Julia Lawall (1):
      x86, mce, AMD: Fix leaving freed data in a list

Kleber Sacilotto de Souza (1):
      ehea: fix wrongly reported speed and port

Matvejchikov Ilya (1):
      NET: slip, fix ldisc->open retval

Paul Fox (1):
      libertas: fix cmdpendingq locking

Pavel Shilovsky (1):
      CIFS: Fix memory over bound bug in cifs_parse_mount_options

Thomas Gleixner (1):
      tick: Clear broadcast active bit when switching to oneshot

Thomas Jarosch (1):
      vmxnet3: Fix inconsistent LRO state after initialization

Timo Warns (1):
      Validate size of EFI GUID partition entries.

Youquan Song (1):
      x86, apic: Fix spurious error interrupts triggering on all non-boot APs

