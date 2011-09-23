Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1IWObd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:31:33 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39498 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab1IWOb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:31:28 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/10] drbd: part 10 of adding multiple volume support to drbd
Date: Fri, 23 Sep 2011 16:31:15 +0200
Message-Id: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
478 patches. This is the tenth installment containing 10 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is a56df23^...ee04546

This patch series contains:
 * Introduces header 100, which allows 16 bit volume numbers.
