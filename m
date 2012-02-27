Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2B0Bes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 20:34:48 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:51159 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab2B0Ber (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 20:34:47 -0500
Date: Sun, 26 Feb 2012 20:30:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, konrad@darnok.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) tag stable/for-linus-fixes-3.3-rc5 
Message-ID: <20120227013027.GA16501@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F4ADD85.001A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following tag:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-fixes-3.3-rc5

which has two fixes to fix a memory corruption bug when WC pages never get
converted back to WB but end up being recycled in the general memory
pool as WC.

There is a better way of fixing this, but there is not enough time to do the
full benchmarking to pick one of the right options - so picking the one that
favors stability for right now.

Please pull!

 arch/x86/xen/enlighten.c |    6 ++----
 arch/x86/xen/mmu.c       |    8 ++++----
 2 files changed, 6 insertions(+), 8 deletions(-)

Konrad Rzeszutek Wilk (2):
      xen/setup: Remove redundant filtering of PTE masks.
      xen/pat: Disable PAT support for now.

