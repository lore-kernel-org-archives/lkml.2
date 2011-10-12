Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1JLM1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:27:39 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33895 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1JLM1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:38 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/13] drbd: part 18 of adding multiple volume support to drbd
Date: Wed, 12 Oct 2011 14:27:22 +0200
Message-Id: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
443 patches. This is the eighteenth installment containing 13 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is b2c8435^...de24b9f

This patch series contains:
 * Improvements to the new generic netlink interface
 * Cleanups
