Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804Ab1JFNiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:38:15 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34097 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769Ab1JFNiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/15] drbd: part 15 of adding multiple volume support to drbd
Date: Thu,  6 Oct 2011 15:37:45 +0200
Message-Id: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
459 patches. This is the fifteenth installment containing 15 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is ce51036^...c605e11

This patch series contains:
 * RCU for disk_conf
 * Boolean configure options got two values; eliminate the "no-" prefixes

