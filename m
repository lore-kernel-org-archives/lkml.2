Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965098Ab2I1XlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:41:14 -0400
Received: from nm24.bullet.mail.bf1.yahoo.com ([98.139.212.183]:40308 "HELO
	nm24.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965044Ab2I1XlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:41:10 -0400
X-Yahoo-Newman-Id: 233281.10138.bm@smtp115.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1FkQ2X0VM1kXfa2g0m.cF1QnNa_iLOeIKzU2.hcurVZbdip
 x9f9zMWihi34B.lGfxWYAcmZ4QS8HWoP8ip7v5dG4YZ4Sy9VqEx2t3PSjkZF
 BID_47I0gR.t6b5W1HEvtW1zvTw1Z21muNvLKIShWLW1lLXMU.A.qUsWsrvr
 oaLJaHSYRC0n1gxFi1vq833eyutE3ykai_pdza0TSDpU1.pNov2h9I8sNiUU
 ah8_6YpL7XWwBrdeAhSnoTM60KEjDtJjgYAs2Yo0pi1FOI.Pyq8NG0el2kQS
 _I1lgB6Hq_ltfgAPrS9_Tr3NDmAYA6q733Ha4OGoFjNY4M3G5H6.ZCP2mudE
 VOQ8Rw6TlhXkPtG6DcU6ZkB37mMTx0DqO7_iASw4H4vYFQ9K4mYmWGEFhPwb
 qeAoU3A5XCEznKU6CW_LTynX2WZUhuFcLTf.MbGnJXf79kU3UvOvR
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>, linux-doc@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v6 3/10] Generate doc comments for rbtree.h in Kernel-API
Date: Fri, 28 Sep 2012 18:40:18 -0500
Message-Id: <1348875625-28669-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
References: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 Documentation/DocBook/kernel-api.tmpl |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index 00687ee..d270f1e 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -43,6 +43,9 @@
      <sect1><title>Doubly Linked Lists</title>
 !Iinclude/linux/list.h
      </sect1>
+     <sect1><title>Red-Black Trees</title>
+!Iinclude/linux/rbtree.h
+     </sect1>
   </chapter>
 
   <chapter id="libc">
-- 
1.7.3.4

