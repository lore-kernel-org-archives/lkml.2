Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1JMKcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:32:20 -0400
Received: from mail09.linbit.com ([212.69.161.110]:58079 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1JMKcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:32:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/10] drbd: part 19 of adding multiple volume support to drbd
Date: Thu, 13 Oct 2011 12:32:06 +0200
Message-Id: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
436 patches. This is the nineteenth installment containing 10 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is 9b20c38^...d581c5d

This patch series contains:
 * Detaching from frozen backing block devices (merge from 8.3)
 * Cleanups
