Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0EGLNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 07:13:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:42718 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab0EGLNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 07:13:16 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 7 May 2010 21:13:07 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19427.62915.600797.337003@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Bryant <tenminjoe@yahoo.com>,
       Gabriele A "." Trombetti 
	<g.trombetti.lkrnl1213@logicschema.com>,
       Janos Haar <janos.haar@netcenter.hu>
Subject: [PULL REQUEST] two small fixes for md for 2.6.34
X-Mailer: VM 8.0.13 under 22.3.1 (x86_64-pc-linux-gnu)
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 please consider pulling these two bug fixes for md for 2.6.34.
 They are not very serious bugs but can lead to unexpected behaviour
 and in one case doesn't protect your data quite as much as you would
 like is certain cases.

Thanks,
NeilBrown


The following changes since commit 722154e4cacf015161efe60009ae9be23d492296:
  Linus Torvalds (1):
        Merge branch 'zerolen' of git://git.kernel.org/.../jgarzik/misc-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Gabriele A. Trombetti (1):
      md/raid6: Fix raid-6 read-error correction in degraded state

NeilBrown (1):
      md: restore ability of spare drives to spin down.

 drivers/md/md.c    |   10 ++++++++--
 drivers/md/raid5.c |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)
