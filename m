Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768911Ab2KOUHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 15:07:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63137 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423636Ab2KOUHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 15:07:31 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        paul@pwsan.com, i.mazanov@gmail.com, jon-hunter@ti.com
User-Agent: alot/0.3.2+
To: torvalds@linux-foundation.org
Message-ID: <20121115200727.7155.72698@nucleus>
Subject: common clk fixes for 3.7-rc6, part 2
Date: Thu, 15 Nov 2012 12:07:27 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to 93532c8a4890871aa0d84dd91b80dad9f58542e0:

  clk: remove inline usage from clk-provider.h (2012-11-15 11:38:34 -0800)

----------------------------------------------------------------
GCC 4.7 users get compilation errors from unnecessary use of inline in
clk-provider.h.  This pull request fixes the regression by removing inline
usage from those function declarations.

----------------------------------------------------------------
Igor Mazanov (1):
      clk: remove inline usage from clk-provider.h

 include/linux/clk-provider.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
