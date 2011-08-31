Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1HaPLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:11:17 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59850 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab1HaPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/16] drbd: part 3 of adding multiple volume support to drbd
Date: Wed, 31 Aug 2011 17:10:52 +0200
Message-Id: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
492 patches. This is the third installment containing 16 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is ac0f15d...9a88f41

The most noticeable change is the support for multiple replicated volumes in
a single DRBD connection.  Write-ordering is obeyed among all writes in all
volumes in a single connection.  This feature is really important for users
who use DRBD for mirroring over longer distances. (Protocol A).

