Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209Ab1ESS3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:29:53 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43265 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933799Ab1ESSZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:25:38 -0400
X-Sasl-enc: X7puba+ncuPxkvyGpMf4VhckNFuDJEZ2QSnGmO7oq+Gi 1305829537
Date: Thu, 19 May 2011 11:24:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/21] 2.6.32.41-longterm review
Message-ID: <20110519182446.GA23751@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.41 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday, May 22 2011, 18:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.41-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

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
