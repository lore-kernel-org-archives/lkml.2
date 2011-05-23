Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab1EWSl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:41:28 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43381 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756328Ab1EWSlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:41:24 -0400
X-Sasl-enc: LdSbez9E9mwaDx8HL9TEm4RHavzrE8Sd8HVBE9Jl3nhf 1306176082
Date: Mon, 23 May 2011 11:41:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.14
Message-ID: <20110523184125.GC12920@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.14 kernel.

This is primarily for the use of those people who are stuck using the
.33-rt kernel.  Anyone else who really wants to use the .33 kernel tree
is welcome to use this one as well.

I'll be maintaining it for a while longer as it looks like the -rt tree
isn't moving forward to any newer kernel any time soon.

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 -
 arch/x86/include/asm/apicdef.h           |    1 
 arch/x86/kernel/cpu/amd.c                |    4 +--
 arch/x86/kernel/cpu/mcheck/mce_amd.c     |    1 
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   12 ++++++----
 arch/x86/kernel/ptrace.c                 |   36 ++++++++++++++++++++++---------
 drivers/net/Makefile                     |    6 ++---
 drivers/net/ehea/ehea_ethtool.c          |   21 +++++++++++-------
 drivers/net/hydra.c                      |   14 ++++++------
 drivers/net/ne-h8300.c                   |   16 ++++++-------
 drivers/net/slip.c                       |    4 ++-
 drivers/net/vmxnet3/vmxnet3_ethtool.c    |    3 ++
 drivers/net/wireless/libertas/cmd.c      |    6 +++--
 drivers/net/zorro8390.c                  |   12 +++++-----
 drivers/scsi/megaraid/megaraid_sas.c     |    3 ++
 firmware/Makefile                        |    2 -
 fs/cifs/connect.c                        |   10 ++++++--
 fs/cifs/sess.c                           |    4 ++-
 fs/partitions/efi.c                      |    6 +++++
 include/linux/ptrace.h                   |   13 ++++++++++-
 include/linux/sched.h                    |    3 ++
 kernel/exit.c                            |    2 -
 kernel/ptrace.c                          |   17 ++++++++++++++
 kernel/time/clocksource.c                |    2 -
 kernel/time/tick-broadcast.c             |   12 +++++++++-
 net/dccp/options.c                       |    2 +
 scripts/mkmakefile                       |    4 ++-
 27 files changed, 156 insertions(+), 62 deletions(-)

Bjørn Mork (1):
      megaraid_sas: Sanity check user supplied length before passing it to dma_alloc_coherent()

Borislav Petkov (2):
      Revert "x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors"
      x86, AMD: Fix ARAT feature setting again

Dan Rosenberg (1):
      dccp: handle invalid feature options length

Frederic Weisbecker (2):
      x86, hw_breakpoints: Fix racy access to ptrace breakpoints
      ptrace: Prepare to fix racy accesses on task breakpoints

Geert Uytterhoeven (3):
      ne-h8300: Fix regression caused during net_device_ops conversion
      hydra: Fix regression caused during net_device_ops conversion
      zorro8390: Fix regression caused during net_device_ops conversion

Greg Kroah-Hartman (1):
      Linux 2.6.33.14

Jan Beulich (1):
      fixes for using make 3.82

Jeff Layton (2):
      cifs: check for bytes_remaining going to zero in CIFS_SessSetup
      cifs: add fallback in is_path_accessible for old servers

John Stultz (1):
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

