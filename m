Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab1KVBMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:12:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755Ab1KVBMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:12:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Geoff Thorpe <geoff@geoffthorpe.net>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] uio: documentation fixups
Date: Mon, 21 Nov 2011 17:11:23 -0800
Message-Id: <1321924284-26414-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321924284-26414-1-git-send-email-gregkh@suse.de>
References: <20111122005858.GB25420@kroah.com>
 <1321924284-26414-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geoff Thorpe <geoff@geoffthorpe.net>

The 'name' attribute of struct uio_mem wasn't documented, and the note
about 'kobj' is stale and needs to be changed to 'map'.

Signed-off-by: Geoff Thorpe <geoff@geoffthorpe.net>
Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/uio-howto.tmpl |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index 54883de..ac3d001 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -521,6 +521,11 @@ Here's a description of the fields of <varname>struct uio_mem</varname>:
 
 <itemizedlist>
 <listitem><para>
+<varname>const char *name</varname>: Optional. Set this to help identify
+the memory region, it will show up in the corresponding sysfs node.
+</para></listitem>
+
+<listitem><para>
 <varname>int memtype</varname>: Required if the mapping is used. Set this to
 <varname>UIO_MEM_PHYS</varname> if you you have physical memory on your
 card to be mapped. Use <varname>UIO_MEM_LOGICAL</varname> for logical
@@ -553,7 +558,7 @@ instead to remember such an address.
 </itemizedlist>
 
 <para>
-Please do not touch the <varname>kobj</varname> element of
+Please do not touch the <varname>map</varname> element of
 <varname>struct uio_mem</varname>! It is used by the UIO framework
 to set up sysfs files for this mapping. Simply leave it alone.
 </para>
-- 
1.7.7.3

