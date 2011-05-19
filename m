Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355Ab1ESSce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:32:34 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53748 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934248Ab1ESScb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:32:31 -0400
X-Sasl-enc: Q2/Fe+//KdPICIMHivWbjkOLOvoDf4/QQ6ptp2/f2CwK 1305829950
Date: Thu, 19 May 2011 11:31:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/24] 2.6.33.14-longterm review
Message-ID: <20110519183133.GA26776@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.33.14 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday, May 22 2011, 18:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.14-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                 |    2 +-
 arch/x86/include/asm/apicdef.h           |    1 +
 arch/x86/kernel/cpu/amd.c                |    4 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c     |    1 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   12 ++-
 arch/x86/kernel/ptrace.c                 |   36 +++++++---
 drivers/net/Makefile                     |    6 +-
 drivers/net/ehea/ehea_ethtool.c          |   21 +++--
 drivers/net/hydra.c                      |   14 ++--
 drivers/net/ne-h8300.c                   |   16 ++--
 drivers/net/slip.c                       |    4 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c    |    3 +
 drivers/net/wireless/libertas/cmd.c      |    6 +-
 drivers/net/zorro8390.c                  |   12 ++--
 drivers/scsi/megaraid/megaraid_sas.c     |    3 +
 firmware/Makefile                        |    2 +-
 fs/cifs/connect.c                        |   10 ++-
 fs/cifs/sess.c                           |    4 +-
 fs/partitions/efi.c                      |    6 ++
 include/linux/ptrace.h                   |   13 +++-
 include/linux/sched.h                    |    3 +
 kernel/exit.c                            |    2 +-
 kernel/ptrace.c                          |   17 ++++
 kernel/time/clocksource.c                |    2 +-
 kernel/time/tick-broadcast.c             |   12 +++-
 mm/shmem.c                               |  119 ++++++++++++++++--------------
 net/dccp/options.c                       |    2 +
 scripts/mkmakefile                       |    4 +-
 28 files changed, 219 insertions(+), 118 deletions(-)
