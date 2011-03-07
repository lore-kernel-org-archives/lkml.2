Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab1CGLfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:35:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab1CGLf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:35:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MAINTAINERS: Add a guideline on notification of new userspace
 API/ABI elements
To: mtk.manpages@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Mon, 07 Mar 2011 11:35:23 +0000
Message-ID: <20110307113523.24025.37925.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a guideline indicating who to notify about new userspace API/ABI elements,
such as new system calls or error codes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 MAINTAINERS |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 560ecce..694bec2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -63,7 +63,10 @@ trivial patch so apply some common sense.
 	please Cc: security@kernel.org, especially if the maintainer
 	does not respond.
 
-8.	Happy hacking.
+8.	When adding new userspace API/ABI elements, notably system calls and
+	error codes, please cc <linux-api@vger.kernel.org>.
+
+9.	Happy hacking.
 
 Descriptions of section entries:
 

