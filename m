Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2JQPFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:05:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36322 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab2JQPFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:05:37 -0400
MIME-Version: 1.0
Date: Wed, 17 Oct 2012 11:05:37 -0400
Message-ID: <CAPhKKr-c8ATOswuvxe+vBoLh6B-7VZSSiOkS5vbvzBCX7RLewA@mail.gmail.com>
Subject: [PATCH] RCU documentation: Correct the name of a reference
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: multipart/mixed; boundary=047d7b2ed82569f10104cc429a41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b2ed82569f10104cc429a41
Content-Type: text/plain; charset=ISO-8859-1

[Attaching the patch as gmail breaks the patches]

Trying to go through the history of RCU (not for the weak
minded) led me to search for a non-existent paper.

Correct it to the actual reference

Signed-off-by: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

Index: linux/Documentation/RCU/RTFP.txt
===================================================================
--- linux.orig/Documentation/RCU/RTFP.txt
+++ linux/Documentation/RCU/RTFP.txt
@@ -186,7 +186,7 @@ Bibtex Entries

 @article{Kung80
 ,author="H. T. Kung and Q. Lehman"
-,title="Concurrent Maintenance of Binary Search Trees"
+,title="Concurrent Manipulation of Binary Search Trees"
 ,Year="1980"
 ,Month="September"
 ,journal="ACM Transactions on Database Systems"

--047d7b2ed82569f10104cc429a41
Content-Type: application/octet-stream; name="rcu-doc-fix.patch"
Content-Disposition: attachment; filename="rcu-doc-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8eknzrc0

UkNVIGRvY3VtZW50YXRpb246IENvcnJlY3QgdGhlIG5hbWUgb2YgYSByZWZlcmVuY2UKClRyeWlu
ZyB0byBnbyB0aHJvdWdoIHRoZSBoaXN0b3J5IG9mIFJDVSAobm90IGZvciB0aGUgd2VhawptaW5k
ZWQpIGxlZCBtZSB0byBzZWFyY2ggZm9yIGEgbm9uLWV4aXN0ZW50IHBhcGVyLgoKQ29ycmVjdCBp
dCB0byB0aGUgYWN0dWFsIHJlZmVyZW5jZQoKU2lnbmVkLW9mZi1ieTogRGhhdmFsIEdpYW5pIDxk
aGF2YWwuZ2lhbmlAZ21haWwuY29tPgpDYzogUGF1bCBNY0tlbm5leSA8cGF1bG1ja0BsaW51eC52
bmV0LmlibS5jb20+CkNjOiBQZXRlciBaaWpsc3RyYSA8YS5wLnppamxzdHJhQGNoZWxsby5ubD4K
CkluZGV4OiBsaW51eC9Eb2N1bWVudGF0aW9uL1JDVS9SVEZQLnR4dAo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBs
aW51eC5vcmlnL0RvY3VtZW50YXRpb24vUkNVL1JURlAudHh0CisrKyBsaW51eC9Eb2N1bWVudGF0
aW9uL1JDVS9SVEZQLnR4dApAQCAtMTg2LDcgKzE4Niw3IEBAIEJpYnRleCBFbnRyaWVzCiAKIEBh
cnRpY2xle0t1bmc4MAogLGF1dGhvcj0iSC4gVC4gS3VuZyBhbmQgUS4gTGVobWFuIgotLHRpdGxl
PSJDb25jdXJyZW50IE1haW50ZW5hbmNlIG9mIEJpbmFyeSBTZWFyY2ggVHJlZXMiCissdGl0bGU9
IkNvbmN1cnJlbnQgTWFuaXB1bGF0aW9uIG9mIEJpbmFyeSBTZWFyY2ggVHJlZXMiCiAsWWVhcj0i
MTk4MCIKICxNb250aD0iU2VwdGVtYmVyIgogLGpvdXJuYWw9IkFDTSBUcmFuc2FjdGlvbnMgb24g
RGF0YWJhc2UgU3lzdGVtcyIK
--047d7b2ed82569f10104cc429a41--
