Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0JGTaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:30:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46423 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab0JGTaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:30:20 -0400
Date: Thu, 7 Oct 2010 21:30:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Please pull hwpoison fixes for 2.6.36
Message-ID: <20101007193015.GA8091@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Some last minute hwpoison bug fixes. It turned out the address 
granuality information for errors was not passed out to user space,
and this broke someone who wanted to use it. Fixed this
with a straight forward change to signal.c. And a couple of other
bug fixes that have accumulated.

Please consider pulling. Thanks,
-Andi

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison-fixes

Andi Kleen (3):
      HWPOISON: Copy si_addr_lsb to user
      HWPOISON: Report correct address granuality for AO huge page errors
      HWPOISON: Stop shrinking at right page count

Naoya Horiguchi (1):
      page-types.c: fix name of unpoison interface

 Documentation/vm/page-types.c |    2 +-
 kernel/signal.c               |    8 ++++++++
 mm/memory-failure.c           |   12 ++++++------
 3 files changed, 15 insertions(+), 7 deletions(-)

-- 
ak@linux.intel.com -- Speaking for myself only.
