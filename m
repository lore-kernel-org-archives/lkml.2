Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0DMSZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:25:37 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53264
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab0DMSZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:25:35 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add somaxconn to Documentation/sysctl/net.txt
Date: Tue, 13 Apr 2010 13:25:28 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-18-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-doc@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004131325.29104.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add somaxconn to Documentation/sysctl/net.txt

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/sysctl/net.txt |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/sysctl/net.txt b/Documentation/sysctl/net.txt
index df38ef0..2740085 100644
--- a/Documentation/sysctl/net.txt
+++ b/Documentation/sysctl/net.txt
@@ -90,6 +90,12 @@ optmem_max
 Maximum ancillary buffer size allowed per socket. Ancillary data is a sequence
 of struct cmsghdr structures with appended data.
 
+somaxconn
+---------
+
+Maximum backlog of unanswered connections for a listening socket.  Provides
+an upper bound on the "backlog" parameter of the listen() syscall.
+
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
 -------------------------------------------------------
 

-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
