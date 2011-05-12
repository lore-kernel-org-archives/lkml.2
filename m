Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab1ELXMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:12:05 -0400
Received: from cpc7-stkp7-2-0-cust918.10-2.cable.virginmedia.com ([86.22.251.151]:52638
	"EHLO freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757521Ab1ELXME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:12:04 -0400
Date: Fri, 13 May 2011 00:12:05 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: please pull bjdooks' i2c fixes
Message-ID: <20110512231205.GA28409@freya.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following commit:

The following changes since commit ca1376d10810bc2c20c8d0821a9ee04ca2507c01:

  Merge branch 'fix/asoc' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2011-05-12 12:41:30 -0700)

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git for-2639-rc7/i2c-fixes

Wolfram Sang (1):
      i2c: pnx: Fix crash due to wrong init of timer->data

 drivers/i2c/busses/i2c-pnx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

