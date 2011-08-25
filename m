Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1HYOir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:38:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:30223 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1HYOiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:38:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,281,1312182000"; 
   d="scan'208";a="42364330"
Date: Thu, 25 Aug 2011 22:38:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] writeback fix for 3.1-rc4
Message-ID: <20110825143843.GA10080@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull one writeback fix for Linux 3.1-rc4:

git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git urgent-for-linus

It fixes 30% writeback regression on: JBOD setup + very slow random writes.

Wu Fengguang (1):
      squeeze max-pause area and drop pass-good area

 include/linux/writeback.h |   11 -----------
 mm/page-writeback.c       |   15 ++-------------
 2 files changed, 2 insertions(+), 24 deletions(-)

Thanks,
Fengguang
