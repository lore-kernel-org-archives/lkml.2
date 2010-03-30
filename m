Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0C3XOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:14:33 -0400
Received: from kroah.org ([198.145.64.141]:49323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab0C3XNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:13:10 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:59:02 2010
Message-Id: <20100330225902.016686476@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:58:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [86/89] doc: add the documentation for mpol=local
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 5574169613b40b85d6f4c67208fa4846b897a0a1 upstream.

commit 3f226aa1c (mempolicy: support mpol=local tmpfs mount option) added
new mpol=local mount option.  but it didn't add a documentation.

This patch does it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/filesystems/tmpfs.txt |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/tmpfs.txt
+++ b/Documentation/filesystems/tmpfs.txt
@@ -82,11 +82,13 @@ tmpfs has a mount option to set the NUMA
 all files in that instance (if CONFIG_NUMA is enabled) - which can be
 adjusted on the fly via 'mount -o remount ...'
 
-mpol=default             prefers to allocate memory from the local node
+mpol=default             use the process allocation policy
+                         (see set_mempolicy(2))
 mpol=prefer:Node         prefers to allocate memory from the given Node
 mpol=bind:NodeList       allocates memory only from nodes in NodeList
 mpol=interleave          prefers to allocate from each node in turn
 mpol=interleave:NodeList allocates from each node of NodeList in turn
+mpol=local		 prefers to allocate memory from the local node
 
 NodeList format is a comma-separated list of decimal numbers and ranges,
 a range being two hyphen-separated decimal numbers, the smallest and
@@ -134,3 +136,5 @@ Author:
    Christoph Rohland <cr@sap.com>, 1.12.01
 Updated:
    Hugh Dickins, 4 June 2007
+Updated:
+   KOSAKI Motohiro, 16 Mar 2010


