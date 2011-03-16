Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab1CPV2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:28:46 -0400
Received: from kroah.org ([198.145.64.141]:42571 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab1CPVLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Harry Wei <harryxiyou@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: =?UTF-8?q?=5BPATCH=2010/50=5D=20Translate=20Documentation/SecurityBugs=20into=20Chinese?=
Date: Wed, 16 Mar 2011 14:10:48 -0700
Message-Id: <1300309888-5028-10-git-send-email-gregkh@suse.de>
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

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/zh_CN/SecurityBugs |   50 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/zh_CN/SecurityBugs

diff --git a/Documentation/zh_CN/SecurityBugs b/Documentation/zh_CN/SecurityBugs
new file mode 100644
index 0000000..d21eb07
--- /dev/null
+++ b/Documentation/zh_CN/SecurityBugs
@@ -0,0 +1,50 @@
+Chinese translated version of Documentation/SecurityBugs
+
+If you have any comment or update to the content, please contact the
+original document maintainer directly.  However, if you have a problem
+communicating in English you can also ask the Chinese maintainer for
+help.  Contact the Chinese maintainer if this translation is outdated
+or if there is a problem with the translation.
+
+Chinese maintainer: Harry Wei <harryxiyou@gmail.com>
+---------------------------------------------------------------------
+Documentation/SecurityBugs 的中文翻译
+
+如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
+交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
+译存在问题，请联系中文版维护者。
+
+中文版维护者： 贾威威 Harry Wei <harryxiyou@gmail.com>
+中文版翻译者： 贾威威 Harry Wei <harryxiyou@gmail.com>
+中文版校译者： 贾威威 Harry Wei <harryxiyou@gmail.com>
+
+
+以下为正文
+---------------------------------------------------------------------
+Linux内核开发者认为安全非常重要。因此，我们想要知道当一个有关于
+安全的漏洞被发现的时候，并且它可能会被尽快的修复或者公开。请把这个安全
+漏洞报告给Linux内核安全团队。
+
+1) 联系
+
+linux内核安全团队可以通过email<security@kernel.org>来联系。这是
+一组独立的安全工作人员，可以帮助改善漏洞报告并且公布和取消一个修复。安
+全团队有可能会从部分的维护者那里引进额外的帮助来了解并且修复安全漏洞。
+当遇到任何漏洞，所能提供的信息越多就越能诊断和修复。如果你不清楚什么
+是有帮助的信息，那就请重温一下REPORTING-BUGS文件中的概述过程。任
+何攻击性的代码都是非常有用的，未经报告者的同意不会被取消，除非它已经
+被公布于众。
+
+2) 公开
+
+Linux内核安全团队的宗旨就是和漏洞提交者一起处理漏洞的解决方案直
+到公开。我们喜欢尽快地完全公开漏洞。当一个漏洞或者修复还没有被完全地理
+解，解决方案没有通过测试或者供应商协调，可以合理地延迟公开。然而，我们
+期望这些延迟尽可能的短些，是可数的几天，而不是几个星期或者几个月。公开
+日期是通过安全团队和漏洞提供者以及供应商洽谈后的结果。公开时间表是从很
+短（特殊的，它已经被公众所知道）到几个星期。作为一个基本的默认政策，我
+们所期望通知公众的日期是7天的安排。
+
+3) 保密协议
+
+Linux内核安全团队不是一个正式的团体，因此不能加入任何的保密协议。
-- 
1.7.4.1

