Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab1BCRRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:17:04 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35735 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab1BCRRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:17:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=bpoKTgNy2+37qVKxhOQUHgyHHxouFZbcXO9yoUhwFp8icdqeFidD0IAYftKIZDzi5X
         zKbnsNqhtB2nfczq8QJm/rDhq7OnUsw//V8+qybT9rUmEEKLx4DNhRtWTHSwd+WNhCXg
         gA/NdmqFS3Iq7wsBOLZKl4hgQJpBRbTRyujDU=
Date: Fri, 4 Feb 2011 01:16:55 +0800
From: Harry Wei <harryxiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com
Subject: [[PATCH]Translated linux-2.6.37/Documentation/SecurityBugs into
 Chinese
Message-ID: <20110203171653.GA5213@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi us,
     I have translated linux-2.6.37/Documentation/SecurityBugs into Chinese.
You can see when i send it into LKML there are lots of garbled words.I have to take an accessory including my patch. If you don't want to download it, you can also click the URL: http://harrywei.org/blog/?p=29
     Thanks very much.

     I have sent my translated file(not patch file) previous mail but URL is right. So i take the patch accessory in this mail. So sorry :)

	      Best Regards.
	       Harry Wei.

--cWoXeonUoKmBZSoM
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-Translated-linux-2.6-Documentation-SecurityBugs-into.patch"
Content-Transfer-Encoding: 8bit

Signed-off-by: Harry Wei
---
 Documentation/zh_CN/SecurityBugs |   53 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/zh_CN/SecurityBugs

diff --git a/Documentation/zh_CN/SecurityBugs b/Documentation/zh_CN/SecurityBugs
new file mode 100644
index 0000000..ca5786b
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
1.7.0.4


--cWoXeonUoKmBZSoM--
