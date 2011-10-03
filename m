Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab1JCU6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:58:52 -0400
Received: from mail09.linbit.com ([212.69.161.110]:41567 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab1JCU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:58:36 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/10] drbd: part 13 of adding multiple volume support to drbd
Date: Mon,  3 Oct 2011 22:58:23 +0200
Message-Id: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
464 patches. This is the thirteenth installment containing 10 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is ab7e97f^...7afb8a0

The most interesting part of these patches is the introduction of 
reference counting for drbd_tconn objects.
