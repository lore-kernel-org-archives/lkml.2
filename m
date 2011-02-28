Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1B1INY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 03:13:24 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57914 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab1B1INX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 03:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=qKHPSzNT44jUCvYAnSFDTnzkOgWHyhd+lWPAZhenx0CzdpSTeZgTUOQ9aK96YlEvcc
         qBORXlbX8A6KgQPYuykegWGNlNVR6vlrplfT3KPu5rY3X6CkBoQmdKc50/ATfefcdP6O
         XMCTJad43xAnGgOIRzZgBEpmRf6W2lsx8s0rY=
Date: Mon, 28 Feb 2011 16:13:07 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: greg@kroah.com, wangxiaochen0@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Fix spelling mistakes in
 Documentation/zh_CN/SubmittingPatches
Message-ID: <20110228081305.GC5835@gmail.com>
Mail-Followup-To: greg@kroah.com, wangxiaochen0@gmail.com,
	linux-kernel@vger.kernel.org
References: <20110228064746.GA4383@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110228064746.GA4383@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 02:47:46PM +0800, Harry Wei wrote:
> Hi us,
>         From: Xiaochen Wang <wangxiaochen0@gmail.com>
> 
> 	This patch fixes a spelling mistake in Documentation/zh_CN/SubmittingPatches.
> 
> Thanks.
> Best Regards.
> Harry Wei.

   After i fix my mutt configuration file my mutt can send mail with chinese character well. So i resend this patch like following. I am sorry for this.


Signed-off-by: Xiaochen Wang <wangxiaochen0@gmail.com>
Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 Documentation/zh_CN/SubmittingPatches |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/zh_CN/SubmittingPatches b/Documentation/zh_CN/SubmittingPatches
index 9a1a6e1..b72a94e 100644
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
1.7.0.4



