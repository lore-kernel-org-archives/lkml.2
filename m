Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab1IHMpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:45:41 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37513 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab1IHMpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:40 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/16] drbd: part 8 of adding multiple volume support to drbd
Date: Thu,  8 Sep 2011 14:45:21 +0200
Message-Id: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
478 patches. This is the eighth installment containing 16 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is a62c954^...9c7c195

This patch series contains:
 * Nicer logging of state transitions
 * Cleanups and restructuring asender receive functions
 * Multi-slot transactions for the activity log
