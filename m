Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1I2IPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:15:38 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43412 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1I2IPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:15:34 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/12] drbd: part 11 of adding multiple volume support to drbd
Date: Thu, 29 Sep 2011 10:15:19 +0200
Message-Id: <1317284131-17464-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
477 patches. This is the eleventh installment containing 12 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is 6533a57^...570536f

This patch series contains:
 * Code Cleanups, removal of wrong comments
 * Adapt 0 = success / -errno calling convention
 * renamed ee -> peer_req

