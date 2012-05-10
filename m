Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab2EJRTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:19:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36672 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687Ab2EJRSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:18:47 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Richard Purdie <rpurdie@rpsys.net>, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 0/2] mfd: lm3533: update max-current interface
Date: Thu, 10 May 2012 19:18:27 +0200
Message-Id: <1336670309-20858-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <20120510120742.GA29437@localhost>
References: <20120510120742.GA29437@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel, 

Here are the final two changes needed to lm3533 core to reflect changes that
have been decided for the subdriver interfaces.

Sorry I didn't have time to submit a v3 with this included before you applied
the patch.

Thanks,
Johan


Johan Hovold (2):
  mfd: lm3533: remove unused max-current function
  mfd: lm3533: use SI-units for max-current interface

 drivers/mfd/lm3533-ctrlbank.c |   44 +++++++++++++++++++++++++++--------------
 include/linux/mfd/lm3533.h    |    9 +++----
 2 files changed, 33 insertions(+), 20 deletions(-)

-- 
1.7.8.5

