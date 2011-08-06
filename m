Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab1HFSMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 14:12:14 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59516 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab1HFSMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 14:12:12 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org, gregkh@suse.de, michael.hennerich@analog.com,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] staging: IIO: DAC: Delete useless label error_ret in ad5791.c
Date: Sun,  7 Aug 2011 02:09:18 +0800
Message-Id: <1312654158-28057-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  drivers/staging/iio/dac/ad5791.c: In function 'ad5791_probe':
  drivers/staging/iio/dac/ad5791.c:384: warning: label 'error_ret' defined but not used

The label error_ret is defined, but never used, so delete it to avoid annoying warning.

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 drivers/staging/iio/dac/ad5791.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/dac/ad5791.c b/drivers/staging/iio/dac/ad5791.c
index 64770d2..5b00b70 100644
--- a/drivers/staging/iio/dac/ad5791.c
+++ b/drivers/staging/iio/dac/ad5791.c
@@ -381,7 +381,6 @@ error_put_reg_pos:
 	if (!IS_ERR(reg_vdd))
 		regulator_put(reg_vdd);
 
-error_ret:
 	return ret;
 }
 
-- 
1.7.0.4

