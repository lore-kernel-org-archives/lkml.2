Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab1JEJiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:38:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56198 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab1JEJiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/16] drbd: part 14 of adding multiple volume support to drbd
Date: Wed,  5 Oct 2011 11:37:48 +0200
Message-Id: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
459 patches. This is the fourteenth installment containing 16 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is 6d5ade5^...68b38372

This patch series contains:
 * Actually allow changing of the 'integrity-alg' setting while a
   connection is established.
 * Cleanups
