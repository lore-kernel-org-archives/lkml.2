Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1IGQv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:51:28 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48571 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1IGQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:45:58 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/14] drbd: part 7 of adding multiple volume support to drbd
Date: Wed,  7 Sep 2011 16:17:27 +0200
Message-Id: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
492 patches. This is the sixth installment containing 54 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is f6833a3...0f44265

This patch series contains:
 * Use a pre-allocated page as send buffer
 * Use a pre-allocated page as receive buffer
 * Cleanups and renames
