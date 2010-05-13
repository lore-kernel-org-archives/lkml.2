Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0EMOAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:00:25 -0400
Received: from mga07.intel.com ([143.182.124.22]:12566 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755671Ab0EMOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:00:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,222,1272870000"; 
   d="scan'208";a="276706722"
Date: Thu, 13 May 2010 16:00:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [GIT] [2.6.34] MFD fixes
Message-ID: <20100513140045.GA23349@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for being late, I just got back from a (way earlier than expected)
paternity leave. I have one MFD fix pending for 2.6.34, I'd appreciate if you
could still pull:

The following changes since commit be835674b55324c1abe973b15343c3663910c620:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Mark Brown (1):
      mfd: Clean up after WM83xx AUXADC interrupt if it arrives late

 drivers/mfd/wm831x-core.c |    3 +++
 drivers/mfd/wm8350-core.c |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
