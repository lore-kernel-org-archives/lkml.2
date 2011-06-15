Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1FOJzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:55:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47658 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab1FOJzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=b/TNmS1hi+lbDpyKKsROGQMTFm6VTi8LnOhR6ieH7d9OOyRMwpG2Oy7hYtvjGgq3o6
         p0fLLm7p5oZDltRWOpj9gIvICvhsXP4CxCOXuJ9QnApvZcYn7HnXYsYBwZce3MjZTNKP
         Omphx0fJv9xYPvKeQAsskX7zimoBgRaWnyRgo=
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH for 3.0-rc4 0/2] dp83640: bug fixes
Date: Wed, 15 Jun 2011 11:55:18 +0200
Message-Id: <cover.1308129342.git.richard.cochran@omicron.at>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes two status frame related bugs in the driver for the
dp83640 phy. I am not sure whether you would call this a timer fix or
a networking fix, so I put both groups on CC.

Thanks,
Richard


Richard Cochran (2):
  dp83640: fix phy status frame event parsing
  dp83640: drop PHY status frames in the driver.

 drivers/net/phy/dp83640.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

