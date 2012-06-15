Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2FOC57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 22:57:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:33114 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab2FOC56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 22:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165904615"
Date: Fri, 15 Jun 2012 10:57:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: MAINTAINERS: missing git trees
Message-ID: <20120615025751.GB8250@localhost>
References: <1339727661.25607.22.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339727661.25607.22.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Thu, Jun 14, 2012 at 07:34:21PM -0700, Joe Perches wrote:
> These git trees listed in MAINTAINERS don't seem to exist.

Yeah I noticed this, too, several days ago.

> Should they be deleted?

Some trees are no longer exist (ie. netfilter), some are moved. For
example, the btrfs tree is

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git

Perhaps it works best to notify the corresponding email addresses and
ask for update patches. Then after some time, delete the remaining
dead trees.

Thanks,
Fengguang

> git://git.fluff.org/bjdooks/linux.git
> git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
> git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-initiator.git
> git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git
> git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/linux.git
> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
> git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git
> git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/isdn-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath6kl.git
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git rmobile-latest
> git://git.kernel.org/pub/scm/linux/kernel/git/lowpan/lowpan.git
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
> git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git
> git://git.kernel.org/pub/scm/linux/kernel/git/mnc/linux-2.6-iscsi.git
> git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git
> git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/irda-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git
> git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
> git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
