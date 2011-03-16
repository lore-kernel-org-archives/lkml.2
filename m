Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1CPVM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:12:59 -0400
Received: from kroah.org ([198.145.64.141]:42599 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab1CPVLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Harry Wei <harryxiyou@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: =?UTF-8?q?=5BPATCH=2020/50=5D=20Fix=20a=20mistake=20Chinese=20character=20in=20Documentation/zh=5FCN/SubmittingPatches?=
Date: Wed, 16 Mar 2011 14:10:58 -0700
Message-Id: <1300309888-5028-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Wei <harryxiyou@gmail.com>

When i see the file linux-2.6.37/Documentation/zh_CN/SubmittingPatches ,
i find a mistake Chinese character in it. So i give a patch for
correcting this error.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/zh_CN/SubmittingPatches |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/zh_CN/SubmittingPatches b/Documentation/zh_CN/SubmittingPatches
index 9a1a6e1..cc89386 100644
--- a/Documentation/zh_CN/SubmittingPatches
+++ b/Documentation/zh_CN/SubmittingPatches
@@ -100,7 +100,7 @@ http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
 
 将改动拆分，逻辑类似的放到同一个补丁文件里。
 
-例如，如果你的改动里同时有bug修正和性能优化，那么把这些改动才分到两个或
+例如，如果你的改动里同时有bug修正和性能优化，那么把这些改动拆分到两个或
 者更多的补丁文件中。如果你的改动包含对API的修改，并且修改了驱动程序来适
 应这些新的API，那么把这些修改分成两个补丁。
 
-- 
1.7.4.1

