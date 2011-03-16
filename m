Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab1CPVXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:23:45 -0400
Received: from kroah.org ([198.145.64.141]:60892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab1CPVMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Xiaochen Wang <wangxiaochen0@gmail.com>, Harry Wei <harryxiyou@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: =?UTF-8?q?=5BPATCH=2039/50=5D=20Fix=20spelling=20mistakes=20in=20Documentation/zh=5FCN/SubmittingPatches?=
Date: Wed, 16 Mar 2011 14:11:17 -0700
Message-Id: <1300309888-5028-39-git-send-email-gregkh@suse.de>
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

From: Xiaochen Wang <wangxiaochen0@gmail.com>

This patch fixes a spelling mistake in Documentation/zh_CN/SubmittingPatches.

Signed-off-by: Xiaochen Wang <wangxiaochen0@gmail.com>
Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/zh_CN/SubmittingPatches |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/zh_CN/SubmittingPatches b/Documentation/zh_CN/SubmittingPatches
index cc89386..0f4385a 100644
--- a/Documentation/zh_CN/SubmittingPatches
+++ b/Documentation/zh_CN/SubmittingPatches
@@ -230,7 +230,7 @@ pref("mailnews.display.disable_format_flowed_support", true);
 些原因，修正错误，重新提交更新后的改动，是你自己的工作。
 
 Linus不给出任何评论就“丢弃”你的补丁是常见的事情。在系统中这样的事情很
-平常。如果他没有接受你的补丁，也许是由于以下原本：
+平常。如果他没有接受你的补丁，也许是由于以下原因：
 * 你的补丁不能在最新版本的内核上干净的打上。
 * 你的补丁在 linux-kernel 邮件列表中没有得到充分的讨论。
 * 风格问题（参照第2小节）
-- 
1.7.4.1

