Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab2HCBSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 21:18:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65232 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2HCBSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 21:18:20 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Aug 2012 18:17:59 -0700
X-Google-Sender-Auth: dDaeSdxDnBSIcVKWrBBVVWo7n6M
Message-ID: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
Subject: Linux 3.6-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another almost-two-weeks, another merge window over and done with.

Yeah, it's actually only just over 12 days since 3.5 was released, but
I hate the people who send me last-minute pull requests, so I like
pulling the rug out from under people who plan on doing their pull
request in day 13 of the 14-day merge window. If that was your plan,
screw that.

But perhaps more importantly, this time I also have some vacation
travel coming up, and I had the choice between keeping the merge
window open for the full 14 days and pushing out -rc1 from the airport
(free wifi at pdx!), or just closing it early and have a day and a
half to perhaps fix up details before leaving. I obviously chose the
latter.

I tried to notify people who had been good and had lots of stuff
pending in linux-next in a timely manner, so this doesn't come as a
surprise to some of you. And I don't think we really missed any big
merges - this -rc1 is slightly smaller than the previous couple of
merge windows if you look at number of commits, but so was linux-next.
I think it is the summer effect, although we're  talking about less
than a 10% difference.

I do have two more pull requests that are at least tentatively
pending: there's the uapi header file disintegration from David
Howells and the tcm_vhost merge from Nicholas Bellinger, both of which
came in in time. So I'll take another look at those later. The pain of
another header file revolution doesn't excite me, but we'll see.

Anyway, on to the stuff merged. As usual, even the shortlog is too big
to usefully post, but there's the usual breakdown: about two thirds of
the changes are drivers (with the CSR driver from the staging tree
being a big chunk of the noise - christ, that thing is big and wordy
even after some of the crapectomy).

Of the non-driver portion, a bit over a third is arch (arm, x86, tile,
mips, powerpc, m68k), and the rest is a fairly even split among fs,
include file noise, networking, and just "rest".

I'm appending my "merge shortlog", and I'd like to point out that the
person listed is the person I get the pull request from, which is
*not* about authorship, but just about who I ended up getting stuff
from. And I notice that my shell script to generate this missed stuff
like my merge of Andrew's patch-bombs, because they look different
from the normal git merges. But maybe this gives people at least
*some* kind of overview of what kinds of things got merged/updated.

                     Linus

---

Alasdair G Kergon:
  device-mapper updates

Alex Williamson:
  VFIO core

Al Viro:
  VFS changes

Andres Salomon:
  OLPC platform updates

Anton Vorontsov:
  battery updates

Arnd Bergmann:
  arm-soc board specific updates
  arm-soc cleanups
  arm-soc clk changes
  arm-soc defconfig updates
  arm-soc device tree description updates
  arm-soc pincontrol drivers update
  arm-soc power management changes
  arm-soc sparse IRQ conversion
  arm soc-specific updates
  arm-soc spi updates
  arm-soc timer updates
  non-critical arm-soc bug fixes
  samsung arm-soc dma changes
  support for three new arm SoC types

Artem Bityutskiy:
  UBI changes
  UBIFS updates

Avi Kivity:
  KVM updates

Benjamin Herrenschmidt:
  powerpc updates

Ben Myers:
  xfs update

Bjorn Helgaas:
  PCI changes

Bob Liu:
  blackfin changes

Bryan Wu:
  LED subsystem update

Chris Ball:
  MMC updates

Chris Mason:
  large btrfs update

Chris Metcalf:
  arch/tile updates

Cong Wang:
  final kmap_atomic cleanups

Dave Airlie:
  drm updates

David Miller:
  sparc update
  networking update

David Teigland:
  dlm updates

Dmitry Torokhov:
  input layer updates

Florian Tobias Schandinat:
  fbdev updates

Grant Likely:
  irqdomain changes

Greg Kroah-Hartman:
  char/misc patches
  driver core changes
  staging tree patches
  TTY/Serial patches
  USB patches

Greg Ungerer:
  m68knommu arch update

Guenter Roeck:
  hwmon fixes
  hwmon updates

Herbert Xu:
  crypto updates

Ingo Molnar:
  core/iommu changes
  debug-for-linus git tree
  perf updates
  RCU changes
  scheduler changes
  smp/hotplug changes
  timer core changes
  x86/asm changes
  x86/boot changes
  x86 cleanup and cpufeature
  x86/mce changes
  x86 platform changes
  x86/reboot changes
  x86/uv changes

James Bottomley:
  first round of SCSI updates

James Morris:
  security subsystem updates

Jan Kara:
  misc udf, ext2, ext3, and isofs fixes

J. Bruce Fields:
  nfsd changes

Jean Delvare:
  a howmon update
  i2c updates

Jeff Garzik:
  libata updates

Jens Axboe:
  block driver changes
  core block IO bits

Jiri Kosina:
  HID updates
  trivial tree

Joerg Roedel:
  IOMMU updates

Konrad Rzeszutek Wilk:
  frontswap updates
  Xen update

Len Brown:
  ACPI & power management update

Linus Walleij:
  GPIO changes
  pin control changes

Marek Szyprowski:
  DMA-mapping updates

Mark Brown:
  regmap updates
  regulator updates
  spi updates

Mark Salter:
  C6X changes

Martin Schwidefsky:
  s390 updates

Matthew Garrett:
  x86 platform driver updates

Mauro Carvalho Chehab:
  EDAC patches
  media updates
  second set of media updates

Michael Turquette:
  common clk framework changes

Michal Marek:
  kbuild fix
  kconfig changes
  misc kbuild changes
  treewide kbuild cleanup

NeilBrown:
  additional md update
  md updates

Nicholas Bellinger:
  target updates

Ohad Ben-Cohen:
  remoteproc update

Olof Johansson:
  arm-soc board updates
  arm-soc cpuidle enablement for OMAP
  ARM SoC fixes
  arm-soc Marvell Orion device-tree updates

Paul Mundt:
  SuperH updates

Pekka Enberg:
  SLAB changes

Peter Anvin:
  x86/mm changes

Rafael Wysocki:
  power management updates

Ralf Baechle:
  MIPS updates

Richard Weinberger:
  UML fixes

Rob Herring:
  devicetree updates

Roland Dreier:
  final RDMA changes
  InfiniBand/RDMA changes

Russell King:
  ARM audit/signal updates
  ARM DMA engine updates
  ARM updates

Rusty Russell:
  cpumask changes
  virtio update

Sage Weil:
  Ceph changes

Samuel Ortiz:
  MFD bits

Stefan Richter:
  firewire updates

Steve French:
  CIFS update

Steven Rostedt:
  ktest changes
  localmodconfig updates

Steven Whitehouse:
  GFS2 updates

Takashi Iwai:
  sound update

Ted Ts'o:
  ext4 updates
  random subsystem patches

Tejun Heo:
  cgroup changes
  workqueue changes

Thierry Reding:
  PWM subsystem

Tony Luck:
  misc Itanium fixes

Trond Myklebust:
  NFS client updates

Tyler Hicks:
  ecryptfs fixes

Vinod Koul:
  slave-dmaengine update

Wim Van Sebroeck:
  watchdog changes

Wolfram Sang:
  embedded i2c changes

Wu Fengguang:
  writeback updates
