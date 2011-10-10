Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1JJLzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:55:13 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45013 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab1JJLzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:55:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/13] drbd: part 17 of adding multiple volume support to drbd
Date: Mon, 10 Oct 2011 13:54:53 +0200
Message-Id: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
449 patches. This is the seventeenth installment containing 13 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is 80c99c9^...330bea2

This patch series contains:
 * Allow changing of various net options while a connection is established
 * Cleanups
