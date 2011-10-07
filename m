Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944Ab1JGL1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:27:51 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35839 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759732Ab1JGL1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:27:49 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/12] drbd: part 16 of adding multiple volume support to drbd
Date: Fri,  7 Oct 2011 13:27:33 +0200
Message-Id: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
453 patches. This is the sixteenth installment containing 12 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is 80c99c9^...330bea2

This patch series contains:
 * Reference counting for mdev objects
 * RCU for the connection list
 * Removal of rw_semaphore drbd_cfg_rwsem
 * Cleanups: Better names for some constants and variables
