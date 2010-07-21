Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762529Ab0GUFNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:13:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41254 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762176Ab0GUEzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Pu2OzT0VY8d5PWgCcP3JqkiTHWzsJDavb2FLarmSjQCBX0JM23V3eacOUdauNIhRPi
         RE8TR1SYwWRZMKC4TSMUfAlaNm1C0/yJCHAmZDmNXvL/9vO8uERh1NVVqu+jia6Ors4D
         HxBjb78I5WSQRVcw7uj6OF0UAIUVISin3RQkk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 67/67]Documentation/ko_KR/HOWTO
Date: Tue, 20 Jul 2010 21:54:48 -0700
Message-Id: <1279688096-29519-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
References: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/ko_KR/HOWTO |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
index 029fca9..2bf6d3f 100644
--- a/Documentation/ko_KR/HOWTO
+++ b/Documentation/ko_KR/HOWTO
@@ -122,7 +122,7 @@ mtk.manpages@gmail.com의 메인테이너에게 보낼 것을 권장한다.
 
     올바른 패치들을 만드는 법에 관한 훌륭한 다른 문서들이 있다.
     "The Perfect Patch"
-        http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
+        http://userweb.kernel.org/~akpm/stuff/tpp.txt
     "Linux kernel patch submission format"
         http://linux.yyz.us/patch-format.html
 
@@ -192,7 +192,7 @@ Documentation/DocBook/ 디렉토리 내에서 만들어지며 PDF, Postscript, H
 
 여러분이 어디서 시작해야 할진 모르지만 커널 개발 커뮤니티에 참여할 수
 있는 일들을 찾길 원한다면 리눅스 커널 Janitor 프로젝트를 살펴봐라.
-         http://janitor.kernelnewbies.org/
+    http://kernelnewbies.org/KernelJanitors
 그곳은 시작하기에 훌륭한 장소이다. 그곳은 리눅스 커널 소스 트리내에
 간단히 정리되고 수정될 수 있는 문제들에 관하여 설명한다. 여러분은 이
 프로젝트를 대표하는 개발자들과 일하면서 자신의 패치를 리눅스 커널 트리에
@@ -596,7 +596,7 @@ Pat이라는 이름을 가진 여자가 있을 수도 있는 것이다. 리눅
 
 이것이 무엇인지 더 자세한 것을 알고 싶다면 다음 문서의 ChageLog 항을 봐라.
    "The Perfect Patch"
-    http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
+    http://userweb.kernel.org/~akpm/stuff/tpp.txt
 
 
 
@@ -610,7 +610,7 @@ Pat이라는 이름을 가진 여자가 있을 수도 있는 것이다. 리눅
 
 
 ----------
-"개발 프로세스"(http://linux.tar.gz/articles/2.6-development_process) 섹션을
+"개발 프로세스"(http://lwn.net/Articles/94386/) 섹션을
 작성하는데 있어 참고할 문서를 사용하도록 허락해준 Paolo Ciarrocchi에게
 감사한다. 여러분들이 말해야 할 것과 말해서는 안되는 것의 목록 중 일부를 제공해준
 Randy Dunlap과 Gerrit Huizenga에게 감사한다. 또한 검토와 의견 그리고
-- 
1.7.1.rc1.21.gf3bd6

