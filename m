Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1BDP7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:59:44 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58034 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1BDP7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:59:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=D6mZs2v4RVadHSuEoxbPg8kJeUxWZxmxhz29anxncLi542jJmlwLzMgCUO6U9gHkrl
         DUHhij8m/oeAO3nlcni3ieYQLlJHmwDwFUltIoyOM2LqeaxV8qv/rAjRG8JTOaXS+C6G
         WfJI0vRyf5ALz2PItpNzHZ5TCdGM1LthImjl8=
Date: Fri, 4 Feb 2011 23:59:39 +0800
From: Harry Wei <harryxiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com
Subject: [PATCH]a mistake Chinese character in
 linux-2.6/Documentation/zh_CN/SubmittingPatches
Message-ID: <20110204155937.GA3329@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi us,
      When i see the file linux-2.6.37/Documentation/zh_CN/SubmittingPatches , i find a mistake Chinese character in it. So i give a patch for correcting this error.
      Because there are some Chinese characters, i have to take an accessory for including my patch. If you don't want to download it, you can click the URL: http://harrywei.org/blog/?p=35
      Thanks.

  Best Regards.
  Harry Wei.

--/04w6evG8XlLl3ft
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0002-a-mistake-Chinese-character-in-linux-2.6-Documentati.patch"
Content-Transfer-Encoding: 8bit

Signed-off-by: Harry Wei(harryxiyou@gmail.com)
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
1.7.0.4


--/04w6evG8XlLl3ft--
