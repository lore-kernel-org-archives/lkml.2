Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab1IILRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:17:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45595 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712Ab1IILRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:17:39 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/11] drbd: part 9 of adding multiple volume support to drbd
Date: Fri,  9 Sep 2011 13:17:25 +0200
Message-Id: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
478 patches. This is the eighth installment containing 11 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is 35b5cb2^...5129245

This patch series contains:
 * Ensure that state transitions that affect all volumes in a connections
   are only logged as state transition of the connections, not for the volumes
