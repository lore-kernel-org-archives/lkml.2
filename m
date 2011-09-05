Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1IELpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:45:54 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59817 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab1IELpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:49 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [RFC 00/54] drbd: part 6 of adding multiple volume support to drbd
Date: Mon,  5 Sep 2011 13:44:51 +0200
Message-Id: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the first request for review of drbd-8.4. The complete set has 
492 patches. This is the sixth installment containing 54 patches.

The whole set is available here:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

and is jens_for-3.2_drivers...for-jens
and this part is 9ad8be3...02738c9

This patch series consists of mostly small patches that change the calling
convention of many functions, to follow the 0 = success, -errno = failer
pattern.

