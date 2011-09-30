Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab1I3Msc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:48:32 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42728 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587Ab1I3Ms2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:48:28 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/11] drbd: part 12 of adding multiple volume support to drbd
Date: Fri, 30 Sep 2011 14:48:15 +0200
Message-Id: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
471 patches. This is the twelfth installment containing 11 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is f23bb45^...ef9bce0

This patch series contains:
 * Start to use RCU for the objects containing the configuration.
   (Changed seldom, read accessed frequently)
