Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab2CAKde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:33:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33101 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab2CAKdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:33:33 -0500
Date: Thu, 1 Mar 2012 11:33:32 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Message-ID: <20120301103332.GA30156@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:

  git://git.pengutronix.de/git/wsa/linux-2.6.git i2c-embedded/for-3.3

for you to fetch changes up to 844990daa2e69a4258049ba9c2bae1180657dac3:

  i2c: mxs: only flag completion when queue is completely done (2012-02-24 22:28:27 +0100)

----------------------------------------------------------------
Wolfram Sang (1):
      i2c: mxs: only flag completion when queue is completely done

 drivers/i2c/busses/i2c-mxs.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)
