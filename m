Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab2GCX2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 19:28:23 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:38297 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab2GCX2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 19:28:18 -0400
Date: Tue, 3 Jul 2012 16:28:10 -0700
From: Mike Turquette <mturquette@ti.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rnayak@ti.com, mkl@pengutronix.de, u.kleine-koenig@pengutronix.de
Subject: [GIT PULL] clk: fixes for 3.5-rc6
Message-ID: <20120703232810.GA28439@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have one trivial fix for the common clk framework towards 3.5-rc6.
This issue was introduced by the last set of fixes, unfortunately.

Thanks,
Mike

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to 863b13271f1608ab3af6f7a371047d9a66693e38:

  clk: fix parent validation in __clk_set_parent() (2012-07-03 12:05:14 -0700)

----------------------------------------------------------------
The previous set of common clk fixes for -rc5 left an uninitialized int
which could lead to bad array indexing when switching clock parents.
The issue is fixed with a trivial change to the code flow in
__clk_set_parent.

----------------------------------------------------------------
Rajendra Nayak (1):
      clk: fix parent validation in __clk_set_parent()

 drivers/clk/clk.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)
