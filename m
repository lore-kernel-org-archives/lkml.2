Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab1KBPpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:45:09 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:38194 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753636Ab1KBPpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:45:06 -0400
From: Geoff Thorpe <geoff@geoffthorpe.net>
To: linux-kernel@vger.kernel.org
Cc: hjk@hansjkoch.de, gregkh@suse.de, Geoff Thorpe <geoff@geoffthorpe.net>
Subject: [PATCH] uio: documentation fixups
Date: Wed,  2 Nov 2011 11:44:44 -0400
Message-Id: <1320248684-25191-1-git-send-email-geoff@geoffthorpe.net>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1644:host132.hostmonster.com:geofftho:geoffthorpe.com} {sentby:smtp auth 208.111.79.148 authed with geoff@geoffthorpe.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'name' attribute of struct uio_mem wasn't documented, and the note
about 'kobj' is stale and needs to be changed to 'map'.

Signed-off-by: Geoff Thorpe <geoff@geoffthorpe.net>
---

 I was hacking on some UIO-related code and noticed some minor
 glitches in the howto. Just sending it along to get it "off my desk",
 but please feel free to squash this into any other fixes/updates that
 may be pending.

 Regards,
 Geoff

 Documentation/DocBook/uio-howto.tmpl |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index bc4a709..8e98e2f 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -533,6 +533,11 @@ Here's a description of the fields of <varname>struct uio_mem</varname>:
 
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
@@ -565,7 +570,7 @@ instead to remember such an address.
 </itemizedlist>
 
 <para>
-Please do not touch the <varname>kobj</varname> element of
+Please do not touch the <varname>map</varname> element of
 <varname>struct uio_mem</varname>! It is used by the UIO framework
 to set up sysfs files for this mapping. Simply leave it alone.
 </para>
-- 
1.7.3.4

