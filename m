Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab2KTF2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:28:55 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:61866 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2KTF2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:28:54 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 0/7] extcon: Fixes and code updates
Date: Tue, 20 Nov 2012 10:52:36 +0530
Message-Id: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is build tested and based on linux-next (20121115) and extcon
tree at git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git

Sachin Kamat (7):
  extcon: max8997: Fix checkpatch error
  extcon: max8997: Fix a typo
  extcon: Fix return value in extcon-class.c
  extcon: max8997: Fix incorrect error check and return value
  extcon: max77693: Fix incorrect error check and return value
  extcon: max8997: Use devm_kzalloc
  extcon: max77693: Use devm_kzalloc

 drivers/extcon/extcon-class.c    |    2 +-
 drivers/extcon/extcon-max77693.c |   33 ++++++++++++++-------------------
 drivers/extcon/extcon-max8997.c  |   28 ++++++++++++----------------
 3 files changed, 27 insertions(+), 36 deletions(-)

-- 
1.7.4.1

