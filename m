Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab2IQETM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 00:19:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49294 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2IQETK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 00:19:10 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] mfd: update on 88pm860x and max8925
Date: Mon, 17 Sep 2012 12:19:03 +0800
Message-Id: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Updates the patch of max8925 of building issue.
2. Include Jett's PREG regulator patch.
3. Support DT in 88pm860x.

