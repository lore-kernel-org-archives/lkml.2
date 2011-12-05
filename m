Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab1LEVEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:04:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46456 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab1LEVEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:04:22 -0500
Date: Mon, 5 Dec 2011 13:04:05 -0800
From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au
Cc: mingo@elte.hu, yinghai@kernel.org, hpa@zytor.com, tony.luck@intel.com,
        ralf@linux-mips.org, schwidefsky@de.ibm.com, liqin.chen@sunplusct.com,
        lethal@linux-sh.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@redhat.com, jonas@southpole.se,
        lennox.wu@gmail.com, benh@kernel.crashing.org
Subject: linux-next: inclusion request for temporary memblock testing branch
Message-ID: <20111205210405.GK627@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

Can you please include the following branch into linux-next?

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git memblock-kill-early_node_map

This eventually will go through tip/ but Ingo wants it to be tested a
bit before proceeding.

  http://thread.gmane.org/gmane.linux.kernel.cross-arch/11566/focus=1224459

Pulling it into linux-next creates conflicts in three files -
arch/arm/mm/init.c, arch/mips/Kconfig, arch/score/Kconfig.  All
conflicts are trivial.  Both parties try to add something and
combination of the two work fine.  The following branch contains
merged branch for reference.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git memblock-kill-early_node_map-next

allno/modconfig on x86 compile tested.  My randomish test kernel seems
to work fine too.  I tested building on different archs on good part
of the archs on first posting but my cross build setup is sorta
screwed now and couldn't get much done this time but there hasn't been
any substantial change since the first posting.  I'm planning on
getting the cross build env back up soonish once moving is complete.

Thank you.

-- 
tejun
